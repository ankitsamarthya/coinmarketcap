# frozen_string_literal: false

require 'active_support'
require 'active_support/core_ext'
require 'coinmarketcap/version'
require 'http'
require 'nokogiri'

module Coinmarketcap
  API_URI = 'https://api.coinmarketcap.com/v1'.freeze
  BASE_URI = 'https://coinmarketcap.com'.freeze

  # @param rank [Integer] Coins market cap rank greater than or equal
  # @param limit [Integer] Maximum limit set. Defaults to 0 to return all results
  # @param currency [String] Country currency code to convert price
  # @return [Hash]
  # @see https://coinmarketcap.com/api/
  def self.coins(limit: 0, rank: nil, currency: nil)
    params = {
      limit: limit,
      start: rank,
      convert: currency
    }.compact.to_param

    url = "#{API_URI}/ticker/" << "?#{params}" if params.present?
    response = HTTP.get(url)
    JSON.parse(response.body.to_s, symbolize_names: true)
  end

  def self.coin(id, currency = 'USD')
    HTTP.get("https://api.coinmarketcap.com/v1/ticker/#{id}/?convert=#{currency}")
  end

  def self.global(currency = 'USD')
    HTTP.get("https://api.coinmarketcap.com/v1/global/?convert=#{currency}")
  end

  def self.get_historical_price(id, start_date, end_date) # 20170908
    prices = []
    doc = Nokogiri::HTML(open("/currencies/#{id}/historical-data/?start=#{start_date}&end=#{end_date}"))
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
