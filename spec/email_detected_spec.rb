# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EmailDetected do
  before do
    EmailDetected.config do |config|
      config.verifier_email = 'email.detected.test@gmail.com'
    end
  end

  it 'has a version number' do
    expect(EmailDetected::VERSION).not_to be nil
  end

  it 'with an real email address' do
    expect(EmailDetected.exist?('ads-account-noreply@google.com')).to match(
      status: true,
      message: 'The email address has already been registered.'
    )
  end

  context 'without an real email address' do
    it 'do not exist email user 1' do
      expect(EmailDetected.exist?('email1.detected.test.fake@gmail.com')).to match(
        status: false,
        message: 'Requested action not taken:, mailbox unavailable'
      )
    end
    it 'do not exist email user 2' do
      expect(EmailDetected.exist?('email2.detected.test.fake@gmail.com')).to match(
        status: false,
        message: 'Requested action not taken:, mailbox unavailable'
      )
    end
  end

  it 'with invalid email address' do
    expect(EmailDetected.exist?('invalid@email')).to match(
      status: false,
      message: 'The email address invalid.'
    )
  end
end
