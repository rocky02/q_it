RSpec.describe Subscriber do

  context '#valid_sqs_url?' do
    valid_url =  "https://sqs.ap-south-1.amazonaws.com/123432145678/test_123"
    invalid_url1 = "https://sqs.ap-south-1.amazonaws.com/123432145678/test_123.com"
    invalid_url2 = "https://sqs.ap-south-1.amazonaws.com/1234145678/test_123"

    before do 
      stub_const('AwsLoader::AWS', {"access_key_id"=>"access_key", "secret_access_key"=>"secret_access_key", "region"=>"ap-south-1"})
    end

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
    
    before do 
      stub_const('AwsLoader::AWS', {"access_key_id"=>"access_key", "secret_access_key"=>"secret_access_key", "region"=>"ap-south-1"})
    end

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
    let (:aws_sqs_client) { double('sqs') }
    let (:subscriber) { Subscriber.new([url, sleep_period]) }
    let (:sqs) { Aws::SQS::Client.new(stub_responses: true) }
    let (:messages) { [{ message_id: 'test123_msg_01', receipt_handle: '123', body:'hello world' }, { message_id: 'test123_msg_02', receipt_handle: '456', body: 'foo bar' }] }


    before do
      allow(aws_sqs_client).to receive(:client).and_return(sqs)
      allow(AwsSQSClient).to receive(:new).and_return(aws_sqs_client)
      allow(subscriber).to receive(:loop).and_yield
    end
    
    it 'should subscribe to queue given by the url' do
      sqs.stub_responses(:receive_message, messages: messages)
      result = sqs.receive_message(queue_url: url, max_number_of_messages: 1)
      
      allow(sqs).to receive(:receive_message).and_return(result)
      allow(sqs).to receive(:delete_message)

      expect(sqs).to receive(:receive_message).with(queue_url: url, max_number_of_messages: 1)
      messages.map { |m| m[:receipt_handle] }.each do |handle|
        expect(sqs).to receive(:delete_message).with(queue_url: url, receipt_handle: handle)
      end
      subscriber.read_queue
    end
  end
end
