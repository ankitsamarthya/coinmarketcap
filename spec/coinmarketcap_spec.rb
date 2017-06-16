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
end
