# require_relative 'spec_helper'

RSpec.describe Subscriber do
  context '#valid_sqs_url?' do
    valid_url =  "https://sqs.ap-south-1.amazonaws.com/123432145678/test_123"
    invalid_url1 = "https://sqs.ap-south-1.amazonaws.com/123432145678/test_123.com"
    invalid_url2 = "https://sqs.ap-south-1.amazonaws.com/1234145678/test_123"

    it "should validate the url's per aws sqs format and return true for #{valid_url}" do
      expect(Subscriber.valid_sqs_url?(valid_url)).to be_truthy
    end
    
    [invalid_url1, invalid_url2].each do |invalid_url|
      it "should validate the url's per aws sqs format and raise error for #{invalid_url}" do
        expect { Subscriber.valid_sqs_url?(invalid_url) }.to raise_error(QItInvalidArgumentError)
      end
    end
  end

  context '#valid_sleep_period?' do
    valid_sleep_period = '4'
    lower_invalid_sleep_period = '2'
    upper_invalid_sleep_period = '16'
    
    it "should validate the sleep period between 3-15 seconds and return true for #{valid_sleep_period}" do
      expect(Subscriber.valid_sleep_period?(valid_sleep_period)).to be_truthy
    end
    
    [lower_invalid_sleep_period, upper_invalid_sleep_period].each do |invalid_sleep_period|
      it "should validate the sleep period between 3-15 seconds and raise error for #{invalid_sleep_period}" do
        expect { Subscriber.valid_sleep_period?(invalid_sleep_period) }.to raise_error(QItInvalidArgumentError)
      end
    end
  end

  context '#validate' do
    valid_options = ['https://sqs.ap-south-1.amazonaws.com/123432145678/test_123', '4']
    missing_url_options = ['4']
    missing_slp_time_options = ['https://sqs.ap-south-1.amazonaws.com/123432145678/test_123']
    
    it "should validate the options provided for subscription service and return true for #{valid_options}" do
      expect(Subscriber.validate(valid_options)).to be_truthy
    end

    [missing_url_options, missing_slp_time_options].each do |missing_option|
      it "should validate the options provided for subscription service and raise error for #{missing_option}" do
        expect { Subscriber.validate(missing_option) }.to raise_error(QItArgumentError)
      end
    end
  end

  context '#read_queue' do
    let (:url) { "https://sqs.ap-south-1.amazonaws.com/217287599168/test123" }
    let (:sleep_period) { "3" }
    let (:subscriber) { Subscriber.new([url, sleep_period]) }

    it 'should subscribe to queue given by the url' do
      allow(subscriber).to receive(:read_queue).and_return(true)
      expect(subscriber.read_queue).to be_truthy
    end
  end
end
