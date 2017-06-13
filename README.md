# Email Detected

[![CircleCI](https://circleci.com/gh/minhquan4080/email_detected/tree/master.svg?style=svg)](https://circleci.com/gh/minhquan4080/email_detected/tree/master)

Email Detected is a simple tool for verifying an email address exists. It's free and quite easy to use :smile: .

Many times as developers we were putting validation statements for checking email addresses format. This gem will complete your existing setups with validator that actually connects with a given mail server and asks if the address in question exists for real.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'email_detected'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install email_detected

## Usage

To get info about realness of given email address, email_detected connects with a mail server that email's domain points to and pretends to send an email. Some smtp servers will not allow you to do this if you will not present yourself as a real user.

This only needs to be something the receiving SMTP server. We aren't actually sending any mail.

First thing you need to set up is placing something like this either in initializer or in application.rb file:

```ruby
EmailDetected.config do |config|
  config.verifier_email = "youremail@email.com"
end
```

Then just put this in your model e. g:

```ruby
validates_exist_email_of :email
```
Or - if you'd like to use it outside of your models:

```ruby
EmailDetected.exist?(youremail)
```

This method will return with status `true || false` and `message` look like:
```
{:status=>true, :message=>"The email address has already been registered."} 
```

```
{:status=>false, :message=>"The email address invalid."} 
```
or will throw an exception with nicely detailed info about what's wrong.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/email_detected. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the EmailDetected project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/email_detected/blob/master/CODE_OF_CONDUCT.md).
