require_relative 'spec_helper'


RSpec.describe Subscriber do
  context '#valid_sqs_url?' do
    let (:valid_url) { "https://sqs.ap-south-1.amazonaws.com/123432145678/test_123" }
    let (:invalid_url1) { "https://sqs.ap-south-1.amazonaws.com/123432145678/test_123.com" }
    let (:invalid_url2) { "https://sqs.ap-south-1.amazonaws.com/1234145678/test_123" }
    
    it "should validate the url's per aws sqs format and return true for valid url" do
      expect(Subscriber.valid_sqs_url?(valid_url)).to be_truthy
    end

    it "should validate the url's per aws sqs format and raise error for invalid url" do
      expect { Subscriber.valid_sqs_url?(invalid_url1) }.to raise_error(QItInvalidArgumentError)
      expect { Subscriber.valid_sqs_url?(invalid_url2) }.to raise_error(QItInvalidArgumentError)
    end
  end

  context '#valid_sleep_period?' do
    let (:valid_sleep_period) { '4' }
    let (:lower_invalid_sleep_period) { '2' }
    let (:upper_invalid_sleep_period) { '16' }
    
    it 'should validate the sleep period between 3-15 seconds and return true for valid sleep period' do
      expect(Subscriber.valid_sleep_period?(valid_sleep_period)).to be_truthy
      expect { Subscriber.valid_sleep_period?(lower_invalid_sleep_period) }.to raise_error(QItInvalidArgumentError)
      expect { Subscriber.valid_sleep_period?(upper_invalid_sleep_period) }.to raise_error(QItInvalidArgumentError)
    end

    it 'should validate the sleep period between 3-15 seconds and raise error for invalid sleep period' do
      expect { Subscriber.valid_sleep_period?(lower_invalid_sleep_period) }.to raise_error(QItInvalidArgumentError)
      expect { Subscriber.valid_sleep_period?(upper_invalid_sleep_period) }.to raise_error(QItInvalidArgumentError)
    end
  end

  context '#validate' do
    let (:valid_options) { ['https://sqs.ap-south-1.amazonaws.com/123432145678/test_123', '4'] }
    let (:missing_url_options) { ['4'] }
    let (:missing_slp_time_options) { ['https://sqs.ap-south-1.amazonaws.com/123432145678/test_123'] }
    
    it 'should validate the options provided for subscription service and return true for valid options' do
      expect(Subscriber.validate(valid_options)).to be_truthy
    end

    it 'should validate the options provided for subscription service and raise error if any option is invalid' do
      expect { Subscriber.validate(missing_url_options) }.to raise_error(QItArgumentError)
      expect { Subscriber.validate(missing_slp_time_options) }.to raise_error(QItArgumentError)
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
