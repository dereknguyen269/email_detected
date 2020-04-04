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
    expect(EmailDetected.exist?('quannguyen.citynow.test@gmail.com')).to match(
      status: true,
      message: 'The email address has already been registered.'
    )
  end

  context 'without an real email address' do
    it 'do not exist email user' do
      expect(EmailDetected.exist?('email.detected.test.fake@gmail.com')).to match(
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
