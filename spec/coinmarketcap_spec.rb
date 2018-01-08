# frozen_string_literal: true

require 'spec_helper'

describe CoinMarketCap do
  it { expect(CoinMarketCap::VERSION).not_to be nil }

  describe '#coins' do
    it 'returns all coins on default' do
      stub_request(:get, /ticker/).and_return(body: fixture('coins.json'))
      response = subject.coins
      expect(a_request(:get, /ticker\/\?limit=0/)).to have_been_made.once
      expect(response.first).to be_a(Hash)
    end

    it 'returns coins starting with rank' do
      stub_request(:get, /ticker/).and_return(body: fixture('coins_with_rank.json'))
      response = subject.coins(rank: 30)
      expect(a_request(:get, /ticker\/\?limit=0\&start=30/)).to have_been_made.once
      expect(response.first).to be_a(Hash)
    end

    it 'returns coins converted to currency' do
      stub_request(:get, /ticker/).and_return(body: fixture('coins_with_currency.json'))
      response = subject.coins(currency: 'EUR')
      expect(a_request(:get, /ticker\/\?convert=EUR\&limit=0/)).to have_been_made.once
      expect(response.first).to be_a(Hash)
    end
  end

  describe '#coin' do
    it 'returns coin info' do
      stub_request(:get, /ticker\/bitcoin/).and_return(body: fixture('coin.json'))
      response = subject.coin('bitcoin')
      expect(a_request(:get, /ticker\/bitcoin/)).to have_been_made.once
      expect(response).to be_a(Hash)
    end

    it 'returns coin with convert currency' do
      stub_request(:get, /ticker\/bitcoin/).and_return(body: fixture('coin.json'))
      response = subject.coin('bitcoin', currency: 'EUR')
      expect(a_request(:get, /ticker\/bitcoin\/\?convert=EUR/)).to have_been_made.once
      expect(response).to be_a(Hash)
    end

    it 'returns coin error' do
      stub_request(:get, /ticker\/bitco/).and_return(body: fixture('coin_error.json'))
      response = subject.coin('bitco')
      expect(a_request(:get, /ticker\/bitco/)).to have_been_made.once
      expect(response).to be_a(Hash)
    end
  end

  describe '#coin_by_symbol' do
    it 'returns coin' do
      stub_request(:get, /ticker/).and_return(body: fixture('coins.json'))
      response = subject.coin_by_symbol('miota')
      expect(a_request(:get, /ticker\/\?limit=0/)).to have_been_made.once
      expect(response).to be_a(Hash)
      expect(response).not_to be_empty
    end
  end

  describe '#coin_markets' do
    it 'returns markets by id' do
      stub_request(:get, /currencies\/litecoin\/\#markets/).and_return(body: fixture('coin_markets.html'))
      response = subject.coin_markets(id: 'litecoin')
      expect(a_request(:get, /currencies\/litecoin\/\#markets/)).to have_been_made.once
      expect(response).to be_a(Array)
      expect(response.count).to eq(16)
      expect(response.first).to eq(
        source: 'Binance',
        pair: 'IOTA/BTC',
        volume_usd: 97_152_900.0,
        price_usd: 4.13,
        volume_percentage: 38.17,
        last_updated: 'Recently'
      )
    end

    it 'returns markets by symbol' do
      stub_request(:get, /currencies\/litecoin\/\#markets/).and_return(body: fixture('coin_markets.html'))
      stub_request(:get, /ticker/).and_return(body: fixture('coins.json'))

      response = subject.coin_markets(symbol: 'LTC')
      expect(a_request(:get, /ticker\/\?limit=0/)).to have_been_made.once
      expect(a_request(:get, /currencies\/litecoin\/\#markets/)).to have_been_made.once
      expect(response).to be_a(Array)
      expect(response.count).to eq(16)
      expect(response.first).to eq(
        source: 'Binance',
        pair: 'IOTA/BTC',
        volume_usd: 97_152_900.0,
        price_usd: 4.13,
        volume_percentage: 38.17,
        last_updated: 'Recently'
      )
    end

    it do
      expect { subject.coin_markets }.to raise_error(ArgumentError, 'id or symbol is required')
    end
  end

  describe '#global' do
    it 'returns global info' do
      stub_request(:get, /global/).and_return(body: fixture('global.json'))
      response = subject.global
      expect(a_request(:get, /global/)).to have_been_made.once
      expect(response).to be_a(Hash)
    end

    it 'returns global with convert currency' do
      stub_request(:get, /global/).and_return(body: fixture('global.json'))
      response = subject.global(currency: 'EUR')
      expect(a_request(:get, /global\/\?convert=EUR/)).to have_been_made.once
      expect(response).to be_a(Hash)
    end
  end

  describe '#historical_price' do
    it 'parses html and returns prices' do
      stub_request(:get, /historical-data/).and_return(body: fixture('historical_price.html'))
      response = subject.historical_price('request-network', '2018-01-02', '2018-01-08')
      expect(a_request(:get, /currencies\/request-network\/historical-data\/\?end=20180108\&start=20180102/)).to have_been_made.once
      expect(response).to be_a(Array)
      expect(response.first).to be_a(Hash)
      expect(response.first).to eq(
        date: '2018-01-07',
        open: 0.97823,
        high: 1.05,
        low: 0.92497,
        close: 0.935619,
        average: 0.987485
      )
    end
  end
end
