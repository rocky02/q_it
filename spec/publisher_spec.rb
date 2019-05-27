RSpec.describe Publisher do
  
  context '#valid_queue_name?' do
    valid_queue_name = "test_123"
    invalid_queue_name1 = 'a'*81
    invalid_queue_name2 = 'testing/1@2'
    
    it "should validate the queue name as per aws sqs format and return true for valid queue name" do
      expect(Publisher.valid_queue_name?(valid_queue_name)).to be_truthy
    end
    
    [invalid_queue_name1, invalid_queue_name2].each do |invalid_queue_name|
      it "should validate the queue name as per aws sqs format and raise error for #{invalid_queue_name}" do
        expect { Publisher.valid_queue_name?(invalid_queue_name) }.to raise_error(QItInvalidArgumentError)
      end
    end
  end

  context '#valid_sleep_period?' do
    valid_sleep_period = '7'
    lower_invalid_sleep_period = '2'
    upper_invalid_sleep_period = '21'
    
    it "validates the sleep period between 5-20 seconds and returns true for #{valid_sleep_period}" do
      expect(Publisher.valid_sleep_period?(valid_sleep_period)).to be_truthy
    end
    
    [lower_invalid_sleep_period, upper_invalid_sleep_period].each do |invalid_sleep_period|
      it "should validate the sleep period between 5-20 seconds and raise error for #{invalid_sleep_period}" do
        expect { Publisher.valid_sleep_period?(invalid_sleep_period) }.to raise_error(QItInvalidArgumentError)
      end
    end
  end

  context '#create_std_q' do
  	let (:queue_name) { 'test123' }
    let (:options) { [queue_name, 6] }
    let (:publisher) { Publisher.new(options)}
    let (:aws_sqs_client) { double('sqs') }
    let (:client) { double('client') }

    before do
      allow(aws_sqs_client).to receive(:client).and_return(client)
      allow(AwsSQSClient).to receive(:new).and_return(aws_sqs_client)
    end

    it "should read from queue" do
      allow(client).to receive(:create_queue)
      expect(client).to receive(:create_queue).with(queue_name: queue_name)
      publisher.create_std_q
    end
  end

  context "#publish_messages(queue_url)" do
    let (:queue_name) { "test123" }
    let (:queue_url) { "https://sqs.ap-south-1.amazonaws.com/217287599168/test123" }
    let (:message) { { count: 0, timestamp: Time.now.localtime.strftime("%F %T") }.to_json }
    let (:aws_sqs_client) { double('sqs') }
    let (:client) { double('client') }
    let (:publisher) { Publisher.new(queue_name) }

    before do
      allow(aws_sqs_client).to receive(:client).and_return(client)
      allow(AwsSQSClient).to receive(:new).and_return(aws_sqs_client)
    end
    
    it "should publish messages to the queue" do
      allow(client).to receive(:send_message).with({queue_url: queue_url, message_body: message})
      allow(publisher).to receive(:loop).and_yield
      expect(client).to receive(:send_message).with(queue_url: queue_url, message_body: message)
      publisher.publish_messages(queue_url) 
    end
  end

  context '#validate' do

    context 'raise errors while validating arguments' do
      let (:no_args) { [] }
      let (:more_args) { ['foobar', '6', 'barfoo'] }
      let (:less_args) { ['foobar'] }
      
      it 'should raise a QItArgumentError if no arguments are provided' do
        expect { Publisher.validate(no_args) }.to raise_error(QItArgumentError)
      end
      it 'should raise a QItArgumentError if more than 2 arguments are provided' do
        expect { Publisher.validate(more_args) }.to raise_error(QItArgumentError)
      end
      it 'should raise a QItArgumentError if less than 2 arguments are provided' do
        expect { Publisher.validate(less_args) }.to raise_error(QItArgumentError)
      end
    end

    context 'boolean returned for different values of args' do
      let (:correct_options) { ['test_queue_123', '7'] }
      let (:invalid_queue_name) { ['$hello-world', '5'] }
      let (:invalid_sleep_period) { ['test_queue_123', '123'] }

      before do
        allow(Publisher).to receive(:valid_queue_name?)
        allow(Publisher).to receive(:valid_sleep_period?)
      end

      it 'should return truthy value when arguments provided are valid' do
        allow(Publisher).to receive(:valid_queue_name?).and_call_original
        allow(Publisher).to receive(:valid_sleep_period?).and_call_original
        expect(Publisher.validate(correct_options)).to be_truthy
      end

      it 'should return truthy value when arguments provided are valid' do
        expect(Publisher.validate(invalid_queue_name)).to be_falsey
      end
      
      it 'should return truthy value when arguments provided are valid' do
        expect(Publisher.validate(invalid_sleep_period)).to be_falsey
      end
    end
  end

  context '#start' do
    let (:queue_name) { "test123" }
    let (:queue_url) { "https://sqs.ap-south-1.amazonaws.com/217287599168/test123" }
    let (:aws_sqs_client) { double('sqs') }
    let (:sqs) { Aws::SQS::Client.new(stub_responses: true) }
    let (:publisher) { Publisher.new(queue_name) }

    before do
      allow(aws_sqs_client).to receive(:client).and_return(sqs)
      allow(AwsSQSClient).to receive(:new).and_return(aws_sqs_client)
      stub_const('AwsLoader::AWS', {"access_key_id"=>"access_key", "secret_access_key"=>"secret_access_key", "region"=>"ap-south-1"})
      sqs.stub_responses(:create_queue, queue_url: queue_url)
    end
    
    it 'should start the publish service to the queue' do
      queue = sqs.create_queue(queue_name: queue_name)
      expect(publisher).to receive(:create_std_q).and_return(queue)
      expect(publisher).to receive(:publish_messages).with(queue_url)
      publisher.start
    end
  end
end
