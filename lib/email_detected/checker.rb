# frozen_string_literal: true

require 'resolv'
require 'net/smtp'

class EmailDetected::Checker < Net::SMTP
  class MailCheckStatus
    attr_accessor :errors

    def self.rcpt_responses
      @@rcpt_responses ||=
        {
          -1 => :fail, # Validation failed (non-SMTP)
          250 => :valid,       # Requested mail action okay, completed
          251 => :dunno,       # User not local; will forward to <forward-path>
          550 => :invalid,     # Requested action not taken:, mailbox unavailable
          551 => :dunno,       # User not local; please try <forward-path>
          552 => :valid,       # Requested mail action aborted:, exceeded storage allocation
          553 => :invalid,     # Requested action not taken:, mailbox name not allowed
          450 => :valid_fails, # Requested mail action not taken:, mailbox unavailable
          451 => :valid_fails, # Requested action aborted:, local error in processing
          452 => :valid_fails, # Requested action not taken:, insufficient system storage
          500 => :fail,        # Syntax error, command unrecognised
          501 => :invalid,     # Syntax error in parameters or arguments
          503 => :fail,        # Bad sequence of commands
          521 => :invalid,     # <domain> does not accept mail [rfc1846]
          421 => :fail # <domain> Service not available, closing transmission channel
        }
    end

    def initialize(response_code, error = nil)
      errors = []
      errors.push(EmailDetected::MESSAGES[response_code]) unless error.nil?
      @response = (self.class.rcpt_responses.key?(response_code) ?
          response_code : -1)
      @errors = errors
    end

    # Symbolic status of mail address verification.
    #
    # :fail::        Verification failed
    # :dunno::       Verification succeeded, but can't tell about validity
    # :valid::       address known to be valid
    # :valid_fails:: address known to be valid, delivery would have failed temporarily
    # :invalid::     address known to be invalid
    def status
      @@rcpt_responses[@response]
    end

    # true if verified address is known to be valid
    def valid?
      %i[valid valid_fails].include? status
    end

    # true if verified address is known to be invalid
    def invalid?
      status == :invalid
    end
  end

  def self.run(addr, server = nil, decoy_from = nil)
    # FIXME: needs a better mail address parser
    server = get_mail_server(addr[(addr.index('@') + 1)..-1]) if server.nil?

    # This only needs to be something the receiving SMTP server
    # accepts.  We aren't actually sending any mail.
    decoy_from ||= EmailDetected.config.verifier_email
    ret = nil
    begin
      EmailDetected::Checker.start(server) do |smtp|
        ret = smtp.check_mail_addr(addr, decoy_from)
        ret = MailCheckStatus.new(ret.status.to_i)
      end
    rescue Net::SMTPAuthenticationError,
           Net::SMTPServerBusy,
           Net::SMTPSyntaxError,
           Net::SMTPFatalError,
           Net::SMTPUnknownError => e
      ret = MailCheckStatus.new(e.to_s[0..2].to_i, e)
    rescue IOError, TimeoutError, ArgumentError => e
      ret = MailCheckStatus.new(-1, e)
    end
    ret
  end

  def check_mail_addr(to_addr, decoy_from = nil)
    raise IOError, 'closed session' unless @socket
    raise ArgumentError, 'mail destination not given' if to_addr.empty?

    mailfrom decoy_from
    rcptto to_addr
  end

  def self.get_mail_server(host)
    res = Resolv::DNS.new.getresources(host, Resolv::DNS::Resource::IN::MX)
    unless res.empty?
      # FIXME: should return the whole list
      return res.min { |x, y| x.preference <=> y.preference }.exchange.to_s
    end

    nil
  end
end
