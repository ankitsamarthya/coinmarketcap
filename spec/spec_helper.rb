# frozen_string_literal: true

require 'bundler/setup'
require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
end

require 'coinmarketcap'
require 'webmock/rspec'
require 'pry'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'
  config.order = :random
end

WebMock.enable!

def fixture(file_name, json: false, symbolize: false)
  file = File.read("./spec/fixtures/#{file_name}")
  return file unless json
  JSON.parse(file, symbolize_names: symbolize)
end
