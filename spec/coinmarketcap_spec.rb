# frozen_string_literal: true

require 'spec_helper'

describe Coinmarketcap do
  it { expect(Coinmarketcap::VERSION).not_to be nil }

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
      expect(response.first).to be_a(Hash)
    end

    it 'returns coin with convert currency' do
      stub_request(:get, /ticker\/bitcoin/).and_return(body: fixture('coin.json'))
      response = subject.coin('bitcoin', currency: 'EUR')
      expect(a_request(:get, /ticker\/bitcoin\/\?convert=EUR/)).to have_been_made.once
      expect(response.first).to be_a(Hash)
    end

    it 'returns coin error' do
      stub_request(:get, /ticker\/bitco/).and_return(body: fixture('coin_error.json'))
      response = subject.coin('bitco')
      expect(a_request(:get, /ticker\/bitco/)).to have_been_made.once
      expect(response).to be_a(Hash)
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
    context 'with valid id and start and end dates' do
      it 'should receive an non empty array' do
        VCR.use_cassette('historical_price_response') do
          data = Coinmarketcap.get_historical_price('bitcoin', '20170908', '20170914')
          expect(data).to be_a Array
          expect(data.count).to be > 0
        end
      end
    end
  end
end
