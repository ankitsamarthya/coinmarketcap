[![Gem Version](https://badge.fury.io/rb/coinmarketcap.svg)](https://badge.fury.io/rb/coinmarketcap) [![Build Status](https://travis-ci.org/kurt-smith/coinmarketcap.svg?branch=master)](https://travis-ci.org/kurt-smith/coinmarketcap) [![Code Climate](https://codeclimate.com/github/kurt-smith/coinmarketcap/badges/gpa.svg)](https://codeclimate.com/github/kurt-smith/coinmarketcap) [![Coverage Status](https://coveralls.io/repos/github/kurt-smith/coinmarketcap/badge.svg?branch=master)](https://coveralls.io/github/kurt-smith/coinmarketcap?branch=master) [![Issue Count](https://codeclimate.com/github/kurt-smith/coinmarketcap/badges/issue_count.svg)](https://codeclimate.com/github/kurt-smith/coinmarketcap)

# coinmarketcapper

This project has been forked from the `coinmarketcap` gem to provide a wrapper to the public coinmarketcap.com V1 API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'coinmarketcapper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install coinmarketcapper

## Usage

### Coinmarketcap.com API responses

#### All Coins

```ruby
CoinMarketCap.coins(limit: 0, rank:  nil, currency: nil)
```

#### Coin by Coin Market Cap ID

```ruby
CoinMarketCap.coin('litecoin', currency: nil)
```

#### Global

```ruby
CoinMarketCap.global(currency: nil)
```

### Additional Functionality

#### Coin by symbol

```ruby
CoinMarketCap.coin_by_symbol('LTC')
```

#### Retrieve markets by coin

```ruby
CoinMarketCap.coin_markets(id: 'iota')
```

#### Retrieve Coin historical price

```ruby
CoinMarketCap.historical_price('request-network', '2018-01-01', '2018-01-08')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kurt-smith/coinmarketcap. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CoinMarketCap project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/kurt-smith/coinmarketcap/blob/master/CODE_OF_CONDUCT.md).
