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
| `limit`        | int            | Return a maximum of `limit` results (default is nil which returns all results) |

**Examples**
```ruby
  Coinmarketcap.coins
  #=> returns array of all available coins sorted by rank

  Coinmarketcap.coins(limit = 20)
  #=> returns array of only 20 coins sorted by rank
```
**Sample Response**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Bitcoin",
      "symbol": "BTC",
      "website_slug": "bitcoin",
      "rank": 1,
      "circulating_supply": 17243837.0,
      "total_supply": 17243837.0,
      "max_supply": 21000000.0,
      "quotes": {
        "USD": {
          "price": 7046.61259816,
          "volume_24h": 4289789887.93929,
          "market_cap": 121510639045.0,
          "percent_change_1h": -0.09,
          "percent_change_24h": 1.42,
          "percent_change_7d": 4.74
        }
      },
      "last_updated": 1535812825
    },
    {
      "id": 1027,
      "name": "Ethereum",
      "symbol": "ETH",
      "website_slug": "ethereum",
      "rank": 2,
      "circulating_supply": 101689192.0,
      "total_supply": 101689192.0,
      "max_supply": null,
      "quotes": {
        "USD": {
          "price": 287.025145487,
          "volume_24h": 1359873785.37404,
          "market_cap": 29187355119.0,
          "percent_change_1h": 0.5,
          "percent_change_24h": 2.93,
          "percent_change_7d": 2.34
        }
      },
      "last_updated": 1535812836
    }
  ],
  "metadata": {
    "timestamp": 1535812339,
    "num_cryptocurrencies": 1910,
    "error": null
  }
}
```

### Coin
To get information for a specific coin use the `coin` method.

**Parameters**

| Name           | Type           | Description     |
| :------------- | :------------- | :-------------  |
| `id`           | integer        | **required**. Use the ID returned from all coins api |
| `currency`     | string         | return *price*, *24h volume*, and *market cap* in terms of another currency. Valid values are "AUD", "BRL", "CAD", "CHF", "CLP", "CNY", "CZK", "DKK", "EUR", "GBP", "HKD", "HUF", "IDR", "ILS", "INR", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PKR", "PLN", "RUB", "SEK", "SGD", "THB", "TRY", "TWD", "ZAR". (default is "USD") |

**Examples**
```ruby
  Coinmarketcap.coin(1)
  #=> returns information about coin with '1' as its id.
  # Price, 24h volume and market cap are in USD
```
**Sample Response**
```json
{
  "data": {
    "id": 1,
    "name": "Bitcoin",
    "symbol": "BTC",
    "website_slug": "bitcoin",
    "rank": 1,
    "circulating_supply": 17243837.0,
    "total_supply": 17243837.0,
    "max_supply": 21000000.0,
    "quotes": {
      "USD": {
        "price": 7056.36503616,
        "volume_24h": 4310812630.28682,
        "market_cap": 121678808496.0,
        "percent_change_1h": 0.04,
        "percent_change_24h": 1.54,
        "percent_change_7d": 4.88
      }
    },
    "last_updated": 1535813063
  },
  "metadata": {
    "timestamp": 1535812601,
    "error": null
  }
}
```

```ruby
  Coinmarketcap.coin(1, 'EUR')
  #=> returns information about coin with '1' as its id.
  # Price, 24h volume and market cap are in EUR
```
**Sample Response**
```json
{
  "data": {
    "id": 1,
    "name": "Bitcoin",
    "symbol": "BTC",
    "website_slug": "bitcoin",
    "rank": 1,
    "circulating_supply": 17243837.0,
    "total_supply": 17243837.0,
    "max_supply": 21000000.0,
    "quotes": {
      "USD": {
        "price": 7057.5191433,
        "volume_24h": 4315628117.49539,
        "market_cap": 121698709731.0,
        "percent_change_1h": 0.06,
        "percent_change_24h": 1.56,
        "percent_change_7d": 4.9
      },
      "EUR": {
        "price": 6077.93548621,
        "volume_24h": 3716618934.7870364,
        "market_cap": 104806928821.0,
        "percent_change_1h": 0.06,
        "percent_change_24h": 1.56,
        "percent_change_7d": 4.9
      }
    },
    "last_updated": 1535813303
  },
  "metadata": {
    "timestamp": 1535812810,
    "error": null
  }
}
```

### Global
To get global (general) data, use the `global` method.

**Parameters**

| Name           | Type           | Description     |
| :------------- | :------------- | :-------------  |
| `currency`     | string         | return *price*, *24h volume*, and *market cap* in terms of another currency. Valid values are "AUD", "BRL", "CAD", "CHF", "CLP", "CNY", "CZK", "DKK", "EUR", "GBP", "HKD", "HUF", "IDR", "ILS", "INR", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PKR", "PLN", "RUB", "SEK", "SGD", "THB", "TRY", "TWD", "ZAR". (default is "USD") |

**Examples**
```ruby
  Coinmarketcap.global
  #=> returns global data
  # Price, 24h volume and market cap are in USD
```
**Sample Response**
```json
{
  "data":  {
    "active_cryptocurrencies":  1910,
    "active_markets":  13693,
    "bitcoin_percentage_of_market_cap":  52.38,
    "quotes":  {
      "USD":  {
        "total_market_cap":  232365707542.0,
        "total_volume_24h":  12929935868.0
      }
    },
    "last_updated":  1535813364
  },
  "metadata":  {
    "timestamp":  1535812887,
    "error":  null
  }
}
```

```ruby
  Coinmarketcap.global('EUR')
  #=> returns global data
  # Price, 24h volume and market cap are in EUR
```
**Sample Response**
```json
{
  "data":  {
    "active_cryptocurrencies":  1910,
    "active_markets":  13693,
    "bitcoin_percentage_of_market_cap":  52.38,
    "quotes":  {
      "USD":  {
        "total_market_cap":  232328115855.0,
        "total_volume_24h":  12928585948.0
      },
      "EUR":  {
        "total_market_cap":  200080973374.0,
        "total_volume_24h":  11134098218.0
      }
    },
    "last_updated":  1535813303
  },
  "metadata":  {
    "timestamp":  1535812850,
    "error":  null
  }
}
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
