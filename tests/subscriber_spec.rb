require 'rspec'
require 'simplecov'
require_relative '../lib/publisher'
require_relative '../lib/subscriber'

SimpleCov.start

RSpec.describe Subscriber do
  context '#valid_sqs_url?' do
    let (:valid_url) { "https://sqs.ap-south-1.amazonaws.com/123432145678/test_123" }
    
    it "should validate the url's per aws sqs format" do
      expect(Subscriber.valid_sqs_url?(valid_url)).to be_truthy
    end
  end

  context '#valid_sleep_period?' do
    let (:valid_sleep_period) { '4' }
    it 'subscribes from a queue' do
      expect(Subscriber.valid_sleep_period?(valid_sleep_period)).to be_truthy
    end
  end
end
