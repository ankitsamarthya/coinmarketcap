# frozen_string_literal: false

require 'active_support'
require 'active_support/core_ext'
require 'coinmarketcap/version'
require 'http'
require 'nokogiri'

module Coinmarketcap
  API_URL = 'https://api.coinmarketcap.com/v1'.freeze
  BASE_URL = 'https://coinmarketcap.com'.freeze

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

    url = "#{API_URL}/ticker/"
    url << "?#{params}" if params.present?

    response = HTTP.get(url)
    JSON.parse(response.body.to_s, symbolize_names: true)
  end

  # @param id [Integer] Coinmarketcap coin id
  # @param currency [String] Country currency code to convert price
  # @return [Hash]
  def self.coin(id, currency: nil)
    params = {
      convert: currency
    }.compact.to_param

    url = "#{API_URL}/ticker/#{id}/"
    url << "?#{params}" if params.present?

    response = HTTP.get(url)
    JSON.parse(response.body.to_s, symbolize_names: true)
  end

  # @param currency [String] Country currency code to convert price
  # @return [Hash]
  def self.global(currency: nil)
    params = {
      convert: currency
    }.compact.to_param

    url = "#{API_URI}/global/"
    url << "?#{params}" if params.present?

    response = HTTP.get(url)
    JSON.parse(response.body.to_s, symbolize_names: true)
  end

  def self.historical_price(id, start_date, end_date)
    sd = start_date.to_date.to_s.delete('-')
    ed = end_date.to_date.to_s.delete('-')

    url = "#{BASE_URL}/currencies/#{id}/historical-data/?start=#{sd}&end=#{ed}"
    response = HTTP.get(url)
    html = Nokogiri::HTML(response.body.to_s)
    rows = html.css('#historical-data table tbody tr')

    prices = rows.each_with_object([]) do |row, arr|
      td = row.css('td')

      daily = {
        date: Date.parse(td[0].text).to_s,
        open: td[1].text.to_f,
        high: td[2].text.to_f,
        low: td[3].text.to_f,
        close: td[4].text.to_f
      }

      daily[:average] = (daily[:high] + daily[:low]).to_d / 2
      arr << daily
    end

    prices
  end
end
