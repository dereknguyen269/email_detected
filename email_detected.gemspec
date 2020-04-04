# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'email_detected/version'

Gem::Specification.new do |spec|
  spec.name          = 'email_detected'
  spec.version       = EmailDetected::VERSION
  spec.authors       = ['Nguyen Quan']
  spec.email         = ['quannguyen@bestcoder.info']

  spec.summary       = 'Email Detected help checking email address is real.'
  spec.description   = "Email Detected is a simple tool for verifying an email address exists. It's free and quite easy to use :smile: .Many times as developers we were putting validation statements for checking email addresses format. This gem will complete your existing setups with validator that actually connects with a given mail server and asks if the address in question exists for real."
  spec.homepage      = 'https://github.com/dereknguyen269/email_detected'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
