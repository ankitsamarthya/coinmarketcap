require 'coinmarketcap/version'
require 'open-uri'
require 'httparty'
require 'nokogiri'

module Coinmarketcap
  def self.coins(limit = nil)
    if limit.nil?
      HTTParty.get('https://api.coinmarketcap.com/v2/ticker/?structure=array')
    else
      HTTParty.get("https://api.coinmarketcap.com/v2/ticker/?limit=#{limit}&structure=array")
    end
  end

  def self.coins_sort(limit = nil, key = 'rank', order = 'asc')
    if limit.nil?
      response = HTTParty.get('https://api.coinmarketcap.com/v1/ticker/')
    else
      response = HTTParty.get("https://api.coinmarketcap.com/v1/ticker/?limit=#{limit}")
    end
    if ['id', 'name', 'symbol'].include?(key)
      sorted_response = response.sort{ |a, b| a[key] <=> b[key] }
    elsif response[0].keys.include?(key)
      sorted_response = response.sort{ |a, b| a[key].to_f <=> b[key].to_f }
    else
      raise ArgumentError, "wrong argument: '#{key}'"
    end
    if order == 'asc'
      sorted_response
    elsif order == 'desc'
      sorted_response.reverse
    else
      raise ArgumentError, "wrong argument: '#{order}'"
    end
  end

  def self.coin(id, currency = 'USD')
    HTTParty.get("https://api.coinmarketcap.com/v2/ticker/#{id}/?convert=#{currency}")
  end

  def self.global(currency = 'USD')
    HTTParty.get("https://api.coinmarketcap.com/v2/global/?convert=#{currency}")
  end

  def self.get_historical_price(id, start_date, end_date) # 20170908
    prices = []
    doc = Nokogiri::HTML(open("https://coinmarketcap.com/currencies/#{id}/historical-data/?start=#{start_date}&end=#{end_date}"))
    rows = doc.css('tr')
    rows.shift
    rows.each do |row|
      begin
        each_row = Nokogiri::HTML(row.to_s).css('td')
        if each_row.count > 1
          price_bundle = {}
          price_bundle[:date] = Date.parse(each_row[0].text)
          price_bundle[:open] = each_row[1].text.to_f
          price_bundle[:high] = each_row[2].text.to_f
          price_bundle[:low] = each_row[3].text.to_f
          price_bundle[:close] = each_row[4].text.to_f
          price_bundle[:avg] = (price_bundle[:high] + price_bundle[:low]) / 2.0
          prices << price_bundle
        end
      rescue
        next
      end
    end
    prices
  end
end
