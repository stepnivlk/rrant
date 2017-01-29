# Rrant
[![Build Status](https://travis-ci.org/stepnivlk/rrant.svg?branch=master)](https://travis-ci.org/stepnivlk/rrant)

```
➜  ~ rrant
It would be really FUCKING great if NodeJS or mysql could give me a FUCKING shout or ERROR MESSAGE when one of the parameters I'm giving is not the RIGHT FUCKING DATA TYPE INSTEAD OF THROWING A RANDOM ERROR THAT DOESN'T INDICATE A WRONG MOTHERFUCKING DATA TYPE. Five FUCKING hours of debugging later.

[linuxxx][55][https://www.devrant.io/403040]
```

Have you ever wanted to read some rants in your terminal ? Now you can and it will look like you work, since terminal output looks serious!
You can display random rant as a [fortune](https://wiki.archlinux.org/index.php/Fortune) when logging into terminal, or get some rants in your Ruby code.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rrant'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rrant

## Usage

### Standalone
```
Usage: rrant [options]
    -i, --images                     renders images to the console
    -u, --unseen                     shows only unseen rants
    -f, --fetch AMOUNT               fetches new rants in background
    -h, --help                       Display this screen
```

### Ruby

Get random rant from local store as a hash:
```ruby
Rrant.and.rave.in
```

Get random unseen rant from local store and print it to STDOUT:
```ruby
Rrant.and.unseen(true).and.rave.out
```

Get random unseen rant from local store and print it to STDOUT with image:
```ruby
Rrant.and.unseen(true).and.with_images(true).and.rave.out
```

Fetch 20 rants from devRant, store them and get random unseen rant from local store and print it to STDOUT with image:
```ruby
Rrant.and.dos(20).and.unseen(true).and.with_images(true).and.rave.out
```

You can chain methods in different order, or omitt any of them.
Only first ```#and``` method is necessary.
Chain is terminated with ```#rave.in``` (returns hash) or ```#rave.out``` (outputs to STDOUT).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/stepnivlk/rrant. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
