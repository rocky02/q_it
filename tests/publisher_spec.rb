require 'rspec'
require 'simplecov'
SimpleCov.start
require_relative '../lib/publisher'
require_relative '../lib/subscriber'


RSpec.describe Subscriber do
  context '#valid_queue_name?' do
    let (:valid_queue_name) { "test_123" }
    
    it "should validate the url's per aws sqs format" do
      expect(Publisher.valid_queue_name?(valid_queue_name)).to be_truthy
    end
  end

  context '#valid_sleep_period?' do
    let (:valid_sleep_period) { '7' }
    it 'subscribes from a queue' do
      expect(Publisher.valid_sleep_period?(valid_sleep_period)).to be_truthy
    end
  end

  context '#create_std_q' do
  	let (:queue_name) { 'test123' }
    let (:options) { [queue_name, 6] }
    let (:publisher) { Publisher.new(options)}

    it 'should read from queue' do
    	result = publisher.create_std_q
    	url = "https://sqs.ap-south-1.amazonaws.com/217287599168/test123"
    	puts result.queue_url
      expect(result.queue_url).to eq(url)
    end
  end

end
