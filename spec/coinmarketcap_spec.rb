require "spec_helper"

describe Coinmarketcap do
  it "has a version number" do
    expect(Coinmarketcap::VERSION).not_to be nil
  end

  describe "#get_historical_price" do
    context 'with valid id and start and end dates' do
      it "should receive an non empty array" do
        VCR.use_cassette('historical_price_response') do
          data = Coinmarketcap.get_historical_price('bitcoin', '20170908', '20170914')
          expect(data).to be_a Array
          expect(data.count).to be > 0
        end
      end
    end
  end

  describe "#coins" do
    context 'without limit' do
      it "should receive a 200 response with all coins" do
        VCR.use_cassette('all_coin_response') do
          response = Coinmarketcap.coins
          coins = response["data"]
          expect(response.code).to eq(200)
          expect(coins.count).to be > 0
        end
      end
    end

    context 'with limit as 10' do
      it "should receive a 200 response with all coins" do
        VCR.use_cassette('limit_coin_response') do
          response = Coinmarketcap.coins(limit = 10)
          coins = response["data"]
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
          response = Coinmarketcap.coin('1')
          coin = response["data"]
          expect(response.code).to eq(200)
          expect(coin['id']).to eq(1)
        end
      end
    end

    context 'with invalid id' do
      it "should receive a 404 response" do
        VCR.use_cassette('wrong_coin_response') do
          response = Coinmarketcap.coin('random')
          coin = JSON.parse(response.body)
          expect(response.code).to eq(404)
          expect(coin['data']).to be_nil
          expect(coin['metadata']['error']).to match(/id not found/)
        end
      end
    end

    context 'with valid id and a currency code' do
      it "should receive a 200 response with coin details" do
        VCR.use_cassette('single_eur_coin_response') do
          response = Coinmarketcap.coin('1', 'EUR')
          coin = response["data"]
          expect(response.code).to eq(200)
          expect(coin['id']).to eq(1)
          expect(coin['quotes']['EUR']).to be_present
        end
      end
    end
  end

  describe "#global" do
    it "should receive a 200 response with global details" do
      VCR.use_cassette('global_coin_response') do
        response = Coinmarketcap.global
        global = response["data"]
        expect(response.code).to eq(200)
        expect(global['active_cryptocurrencies']).to be > 0
        expect(global['active_markets']).to be > 0
      end
    end

    context 'with valid currency code' do
      it "should receive a 200 response with global details in that currency" do
        VCR.use_cassette('global_eur_coin_response') do
          response = Coinmarketcap.global('EUR')
          global = response["data"]
          expect(response.code).to eq(200)
          expect(global['active_cryptocurrencies']).to be > 0
          expect(global['quotes']['EUR']).to be_present
        end
      end
    end
  end
end
