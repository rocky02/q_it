require 'aws-sdk-sqs'
require_relative 'load_aws'
require_relative 'aws_sqs_client'
require_relative 'q_it_argument_error'

class Subscriber

  attr_reader :sqs, :sleep_period, :queue_url

  def initialize(options)
    @sqs = AwsSQSClient.new.client
    @queue_url = options[0].chomp
    @sleep_period = validate_sleep_period(options[1])
  end

  def validate_sleep_period(sleep_period)
    max_sleep_period = /\A([3-9]|1[0-5])\z/
    begin
      if !sleep_period.nil? && sleep_period.match(max_sleep_period)
        sleep_period.to_i
      else
        raise QItArgumentError.new(self), "Sleep time must be between 3-15 seconds."
      end
    rescue QItArgumentError => e
      puts e
      exit(1)
    end
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
