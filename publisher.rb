require 'aws-sdk-sqs'
require_relative 'load_aws'
require_relative 'aws_sqs_client'
require_relative 'q_it_errors'

class Publisher
  
  attr_reader :sqs, :sleep_period, :queue_name

  def initialize(options)
    @sqs = AwsSQSClient.new.client
    @queue_name = options[0]
    @sleep_period = options[1]
  end

  def self.validate(options)
    raise QItArgumentError, "QItArgumentError :: Incorrect number of arguments. Expected 2 got #{options.count}" if options.count != 2
    
    queue_name = options[0]
    sleep_period = options[1]
    valid_queue_name?(queue_name) && valid_sleep_period?(sleep_period)
  end

  # For Standard Queue
  def create_std_q
    sqs.create_queue(queue_name: queue_name)
  end

  def self.valid_sleep_period?(sleep_period)
    max_sleep_period = /\A([5-9]|1\d{1}|20)\z/
    
    raise QItInvalidArgumentError, "QItInvalidArgumentError :: #{self} Invalid sleep period #{sleep_period}. Sleep period range is between 5-20 seconds." unless sleep_period.match(max_sleep_period)
    
    sleep_period
  end

  def self.valid_queue_name?(queue_name)
    queue_name_regex = /(\w[-]*){3,80}/
    
    raise QItInvalidArgumentError, "QItInvalidArgumentError :: #{self} Queue Name is invalid. Check format." unless queue_name.match?(queue_name_regex)
    
    queue_name
  end

  def publish_messages(queue_url)
    0.upto(Float::INFINITY) do |count|
      message = { count: count, timestamp: Time.now.localtime.strftime("%F %T") }.to_json
      puts "Sending message - #{message}"
      sqs.send_message(queue_url: queue_url, message_body: message)
      sleep(sleep_period.to_i)
    end
  end

  def start
    queue = create_std_q
    puts "Queue URL :: #{queue.queue_url}"
    publish_messages(queue.queue_url)
  end
end
