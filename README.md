[![Gem Version](https://badge.fury.io/rb/coinmarketcap.svg)](https://badge.fury.io/rb/coinmarketcap) [![Build Status](https://travis-ci.org/ankitsamarthya/coinmarketcap.svg?branch=master)](https://travis-ci.org/ankitsamarthya/coinmarketcap) [![Code Climate](https://codeclimate.com/github/ankitsamarthya/coinmarketcap/badges/gpa.svg)](https://codeclimate.com/github/ankitsamarthya/coinmarketcap) [![Coverage Status](https://coveralls.io/repos/github/ankitsamarthya/coinmarketcap/badge.svg?branch=master)](https://coveralls.io/github/ankitsamarthya/coinmarketcap?branch=master) [![Issue Count](https://codeclimate.com/github/ankitsamarthya/coinmarketcap/badges/issue_count.svg)](https://codeclimate.com/github/ankitsamarthya/coinmarketcap)

# Coinmarketcap

A ruby wrapper for the [coinmarketcap.com API](https://coinmarketcap.com/api/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'coinmarketcap'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install coinmarketcap

## Usage

### Coins
To get information for multiple coins use the `coins` method.

**Parameters**

| Name           | Type           | Description     |
| :------------- | :------------- | :-------------  |
| `limit`        | int            | Return a maximum of `limit` results (default is 100, use 0 to return all results) |

**Sample Response**
```json
[
    {
        "id": "bitcoin",
        "name": "Bitcoin",
        "symbol": "BTC",
        "rank": "1",
        "price_usd": "573.137",
        "price_btc": "1.0",
        "24h_volume_usd": "72855700.0",
        "market_cap_usd": "9080883500.0",
        "available_supply": "15844176.0",
        "total_supply": "15844176.0",
        "percent_change_1h": "0.04",
        "percent_change_24h": "-0.3",
        "percent_change_7d": "-0.57",
        "last_updated": "1472762067"
    },
    {
        "id": "ethereum",
        "name": "Ethereum",
        "symbol": "ETH",
        "rank": "2",
        "price_usd": "12.1844",
        "price_btc": "0.021262",
        "24h_volume_usd": "24085900.0",
        "market_cap_usd": "1018098455.0",
        "available_supply": "83557537.0",
        "total_supply": "83557537.0",
        "percent_change_1h": "-0.58",
        "percent_change_24h": "6.34",
        "percent_change_7d": "8.59",
        "last_updated": "1472762062"
    },
    ...
]                               
```

**Examples**
```ruby
  Coinmarketcap.coins
  #=> returns array of 100 coins

  Coinmarketcap.coins(0)
  #=> returns array of all available coins

  Coinmarketcap.coins(20)
  #=> returns array of only 20 coins
```

### Coin
To get information for a specific coin use the `coin` method.

**Parameters**

| Name           | Type           | Description     |
| :------------- | :------------- | :-------------  |
| `id`           | string         | **required**. Return information for coin with `id` |
| `currency`     | string         | return *price*, *24h volume*, and *market cap* in terms of another currency. Valid values are "AUD", "BRL", "CAD", "CHF", "CLP", "CNY", "CZK", "DKK", "EUR", "GBP", "HKD", "HUF", "IDR", "ILS", "INR", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PKR", "PLN", "RUB", "SEK", "SGD", "THB", "TRY", "TWD", "ZAR". (default is "USD") |

**Sample Response**
```json
[
    {
        "id": "bitcoin",
        "name": "Bitcoin",
        "symbol": "BTC",
        "rank": "1",
        "price_usd": "573.137",
        "price_btc": "1.0",
        "24h_volume_usd": "72855700.0",
        "market_cap_usd": "9080883500.0",
        "available_supply": "15844176.0",
        "total_supply": "15844176.0",
        "max_supply": "21000000.0",
        "percent_change_1h": "0.04",
        "percent_change_24h": "-0.3",
        "percent_change_7d": "-0.57",
        "last_updated": "1472762067"
    }
]      
```

**Examples**
```ruby
  Coinmarketcap.coin('BTC')
  #=> returns information about coin with 'BTC' as its ticker symbol.
  # Price, 24h volume and market cap are in USD

  Coinmarketcap.coin('BTC', 'EUR')
  #=> returns information about coin with 'BTC' as its ticker symbol.
  # Price, 24h volume and market cap are in EUR
```

### Global
To get global (general) data, use the `global` method.

**Parameters**

| Name           | Type           | Description     |
| :------------- | :------------- | :-------------  |
| `currency`     | string         | return *price*, *24h volume*, and *market cap* in terms of another currency. Valid values are "AUD", "BRL", "CAD", "CHF", "CLP", "CNY", "CZK", "DKK", "EUR", "GBP", "HKD", "HUF", "IDR", "ILS", "INR", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PKR", "PLN", "RUB", "SEK", "SGD", "THB", "TRY", "TWD", "ZAR". (default is "USD") |

**Sample Response**
```json
{
    "total_market_cap_usd": 201241796675,
    "total_24h_volume_usd": 4548680009,
    "bitcoin_percentage_of_market_cap": 62.54,
    "active_currencies": 896,
    "active_assets": 360,
    "active_markets": 6439,
    "last_updated": 1509909852
}                       
```

**Examples**
```ruby
  Coinmarketcap.global
  #=> returns global data
  # Price, 24h volume and market cap are in USD

  Coinmarketcap.global('EUR')
  #=> returns global data
  # Price, 24h volume and market cap are in EUR
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ankitsamarthya/coinmarketcap. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Coinmarketcap project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ankitsamarthya/coinmarketcap/blob/master/CODE_OF_CONDUCT.md).
