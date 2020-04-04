# frozen_string_literal: true

require 'email_detected/version'

module EmailDetected
  require 'email_detected/config'
  require 'email_detected/checker'
  require 'email_detected/messages'
  require 'email_detected/validates_exist_email'

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  def self.exist?(email)
    return true if config.test_mode
    unless email.match VALID_EMAIL_REGEX
      return { status: false, message: 'The email address invalid.' }
    end

    email_detected = EmailDetected::Checker.run(email)
    if email_detected.invalid?
      resp = { status: false, message: email_detected.errors.first }
    else
      message = email_detected.errors.first || 'The email address has already been registered.'
      resp = { status: true, message: message }
    end
    resp
  end

  def self.config(&block)
    if block_given?
      block.call(EmailDetected::Config)
    else
      EmailDetected::Config
    end
  end
end
