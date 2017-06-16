require "spec_helper"

describe Coinmarketcap do
  it "has a version number" do
    expect(Coinmarketcap::VERSION).not_to be nil
  end

  describe "#coins" do
    context 'without limit' do
      it "should receive a 200 response with all coins" do
        VCR.use_cassette('all_coin_response') do
          response = Coinmarketcap.coins
          coins = JSON.parse(response.body)
          expect(response.code).to eq(200)
          expect(coins.count).to be > 0
        end
      end
    end

    context 'with limit as 10' do
      it "should receive a 200 response with all coins" do
        VCR.use_cassette('limit_coin_response') do
          response = Coinmarketcap.coins(limit = 10)
          coins = JSON.parse(response.body)
          expect(response.code).to eq(200)
          expect(coins.count).to eq(10)
        end
      end
    end
  end

  describe "#coin" do
    context 'with valid id' do
      it "should receive a 200 response with coin details" do
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
      it "should receive a 404 response" do
        VCR.use_cassette('wrong_coin_response') do
          response = Coinmarketcap.coin('random')
          coin = JSON.parse(response.body)
          expect(response.code).to eq(404)
          expect(coin['error']).to match(/id not found/)
        end
      end
    end
  end

  describe "#global" do
    it "should receive a 200 response with global details" do
      VCR.use_cassette('global_coin_response') do
        response = Coinmarketcap.global
        global = JSON.parse(response.body)
        expect(response.code).to eq(200)
        expect(global['active_currencies']).to be > 0
      end
    end

    context 'with valid currency code' do
      it "should receive a 200 response with global details in that currency" do
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
