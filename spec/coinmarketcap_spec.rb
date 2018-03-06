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

  describe "#coins_sort" do
    context 'without limit' do
      it "should sort all coins in ascending order by rank" do
        VCR.use_cassette('all_coin_response') do
          coins = Coinmarketcap.coins_sort
          expect(coins.count).to be > 0
          coins.count.times{ |n| expect(coins[n]['rank'].to_i).to eq(n+1) }
        end
      end
    end

    context 'with limit and string key and asc' do
      it "should sort limited coins in ascending order by string type sort key" do
        VCR.use_cassette('limit_coin_response') do
          coins = Coinmarketcap.coins_sort(10, 'id', 'asc')
          expect(coins.count).to eq(10)
          9.times{ |n| expect(coins[n]['id']).to be < coins[n+1]['id'] }
        end
      end
    end

    context 'with limit and numeric key and desc' do
      it "should sort limited coins in descending order by numeric type sort key" do
        VCR.use_cassette('limit_coin_response') do
          coins = Coinmarketcap.coins_sort(10, 'price_usd', 'desc')
          expect(coins.count).to eq(10)
          9.times{ |n| expect(coins[n]['price_usd'].to_f).to be > coins[n+1]['price_usd'].to_f }
        end
      end
    end

    context 'with invalid sort key' do
      it "should raise ArgumentError" do
        VCR.use_cassette('limit_coin_response') do
          expect{Coinmarketcap.coins_sort(10, 'idd', 'asc')}.to raise_error(ArgumentError)
        end
      end
    end

    context 'with invalid order' do
      it "should raise ArgumentError" do
        VCR.use_cassette('limit_coin_response') do
          expect{Coinmarketcap.coins_sort(10, 'price_usd', 'dsc')}.to raise_error(ArgumentError)
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

    context 'with valid id and a currency code' do
      it "should receive a 200 response with coin details" do
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
