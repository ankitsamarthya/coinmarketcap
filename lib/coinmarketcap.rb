require 'coinmarketcap/version'
require 'httparty'

module Coinmarketcap

  def self.coins(limit = nil)
    if limit.nil?
      HTTParty.get('https://api.coinmarketcap.com/v1/ticker/')
    else
      HTTParty.get("https://api.coinmarketcap.com/v1/ticker/?limit=#{limit}")
    end
  end

  def self.coin(id)
    HTTParty.get("https://api.coinmarketcap.com/v1/ticker/#{id}/")
  end

  def self.global(currency = 'USD')
    HTTParty.get("https://api.coinmarketcap.com/v1/global/?convert=#{currency}")
  end

end
