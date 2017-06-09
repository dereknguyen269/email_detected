module EmailDetected
  module Config
    class << self
      attr_accessor :verifier_email
      attr_accessor :test_mode

      def reset
        # This only needs to be something the receiving SMTP server
        # accepts.  We aren't actually sending any mail.
        @verifier_email = ENV['EMAIL_DETECTED'] || "nobody@nonexistant.com"
        @test_mode = false
        if defined?(Rails) and defined?(Rails.env) and Rails.env.test?
          @test_mode = true
        end
      end
    end
    self.reset
  end
end
