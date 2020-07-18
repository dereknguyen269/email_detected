# frozen_string_literal: true

module EmailDetected
  module Config
    class << self
      attr_accessor :verifier_email
      attr_accessor :test_mode

      def reset
        # This only needs to be something the receiving SMTP server
        # accepts.  We aren't actually sending any mail.
        @verifier_email = ENV['SENDER_EMAIL_DETECTED'] || 'nobody@nonexistant.com'
        @test_mode = false
        if defined?(Rails) && defined?(Rails.env) && Rails.env.test?
          @test_mode = true
        end
      end
    end
    reset
  end
end
