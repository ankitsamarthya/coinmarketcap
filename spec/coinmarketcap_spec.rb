# frozen_string_literal: true

require 'spec_helper'

describe Coinmarketcap do
  it { expect(Coinmarketcap::VERSION).not_to be nil }

  describe '#get_historical_price' do
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
    context 'with valid id' do
      it 'should receive a 200 response with coin details' do
        VCR.use_cassette('single_coin_response') do
          response = Coinmarketcap.coin('bitcoin')
          coin = JSON.parse(response.body)
          expect(response.code).to eq(200)
          expect(coin.count).to eq(1)
          expect(coin.first['id']).to eq('bitcoin')
        end
      end
    end

    context 'with invalid id' do
      it 'should receive a 404 response' do
        VCR.use_cassette('wrong_coin_response') do
          response = Coinmarketcap.coin('random')
          coin = JSON.parse(response.body)
          expect(response.code).to eq(404)
          expect(coin['error']).to match(/id not found/)
        end
      end
    end

    context 'with valid id and a currency code' do
      it 'should receive a 200 response with coin details' do
        VCR.use_cassette('single_eur_coin_response') do
          response = Coinmarketcap.coin('bitcoin', 'EUR')
          coin = JSON.parse(response.body)
          expect(response.code).to eq(200)
          expect(coin.count).to eq(1)
          expect(coin.first['market_cap_eur'].to_i).to be > 0
        end
      end
    end
  end

  describe '#global' do
    it 'should receive a 200 response with global details' do
      VCR.use_cassette('global_coin_response') do
        response = Coinmarketcap.global
        global = JSON.parse(response.body)
        expect(response.code).to eq(200)
        expect(global['active_currencies']).to be > 0
      end
    end

    context 'with valid currency code' do
      it 'should receive a 200 response with global details in that currency' do
        VCR.use_cassette('global_eur_coin_response') do
          response = Coinmarketcap.global('EUR')
          global = JSON.parse(response.body)
          expect(response.code).to eq(200)
          expect(global['total_market_cap_eur']).to be > 0
        end
      end
    end
  end
end
