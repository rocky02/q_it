require 'aws-sdk-sqs'
require_relative 'load_aws'

class Subscriber

  attr_reader :sqs, :sleep_period, :queue_url

  def initialize(options)
    creds = Aws::Credentials.new(AWS["access_key_id"], AWS["secret_access_key"])
    @sqs = Aws::SQS::Client.new(region: AWS["region"], credentials: creds)
    @queue_url = options[0].chomp
    @sleep_period = valid_sleep_period?(options[1]) ? options[1].to_i : 5
  end

  def valid_sleep_period?(sleep_period)
    max_sleep_period = /\A([3-9]|1[0-5])\z/
    !sleep_period.nil? && sleep_period.match?(max_sleep_period)
  end
  

# Todo: URL validation /\A(https:\/\/sqs.)#{AWS["region"]}.amazonaws.com\/\d{12}\/([a-zA-Z]*\d*[-_]*)+|(.fifo)\z/
  def read_queue
    loop do
      result = sqs.receive_message(queue_url: queue_url, max_number_of_messages: 1)
      
      result.messages.each do |msg|
        puts "-"*50
        puts "Message_id: #{msg.message_id}"
        puts "Receipt Handle: #{msg.receipt_handle}"
        puts "Message Body: #{msg.body}"
        sqs.delete_message(queue_url: queue_url, receipt_handle: msg.receipt_handle)
      end
      sleep(sleep_period)
    end
  end

  def start
    read_queue
  end
end
