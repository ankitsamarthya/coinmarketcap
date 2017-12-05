require 'coinmarketcap/version'
require 'open-uri'
require 'httparty'
require 'nokogiri'

module Coinmarketcap

  def self.coins(limit = nil)
    if limit.nil?
      HTTParty.get('https://api.coinmarketcap.com/v1/ticker/')
    else
      HTTParty.get("https://api.coinmarketcap.com/v1/ticker/?limit=#{limit}")
    end
  end

  def self.coin(id, currency = 'USD')
    HTTParty.get("https://api.coinmarketcap.com/v1/ticker/#{id}/?convert=#{currency}")
  end

  def self.global(currency = 'USD')
    HTTParty.get("https://api.coinmarketcap.com/v1/global/?convert=#{currency}")
  end

  def self.get_historical_price(id, start_date, end_date) #20170908
    prices = []
    doc = Nokogiri::HTML(open("https://coinmarketcap.com/currencies/#{id}/historical-data/?start=#{start_date}&end=#{end_date}"))
    rows = doc.css('tr')
    if rows.count == 31
      doc = Nokogiri::HTML(open("https://coinmarketcap.com/assets/#{id}/historical-data/?start=#{start_date}&end=#{end_date}"))
      rows = doc.css('tr')
    end
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
          price_bundle[:avg] = ( price_bundle[:high] + price_bundle[:low] ) / 2.0
          prices << price_bundle
        end
      rescue
        next
      end
    end
    prices
  end

end
