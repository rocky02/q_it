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
    let (:url) { "https://sqs.ap-south-1.amazonaws.com/217287599168/test123" }

    it "should read from queue" do
      allow(publisher).to receive(:create_std_q).and_return(url)
      expect(publisher.create_std_q).to eq(url)
    end
  end

  context "#publish_messages(queue_url)" do
    let (:queue_name) { "test123" }
    let (:url) { "https://sqs.ap-south-1.amazonaws.com/217287599168/test123" }
    let (:publisher) { Publisher.new(queue_name) }

    it "should publish messages to the queue" do
      allow(publisher).to receive(:publish_messages).with(url).and_return(true)
      expect(publisher.publish_messages(url)).to be_truthy      
    end
  end

end
