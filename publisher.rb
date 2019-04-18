require 'aws-sdk-sqs'
require_relative 'load_aws'
require_relative 'aws_sqs_client'
require_relative 'q_it_argument_error'

class Publisher
  
  attr_reader :sqs, :sleep_period, :queue_name

  def initialize(options)
    @sqs = AwsSQSClient.new.client
    @sleep_period = validate_sleep_period(options[1])
    @queue_name = options[0]
  end

  # For Standard Queue
  def create_std_q
    sqs.create_queue(queue_name: queue_name)
  end

  def validate_sleep_period(sleep_period)
    max_sleep_period = /\A([5-9]|1\d{1}|20)\z/
    begin
      if !sleep_period.nil? && sleep_period.match(max_sleep_period)
        sleep_period
      else
        raise QItArgumentError.new(self), "Sleep time must be between 5-20 seconds."
      end
    rescue QItArgumentError => e
      puts e
      exit(1)
    end      
  end

  def publish_messages(queue_url)
    0.upto(Float::INFINITY) do |count|
      message = { count: count, timestamp: Time.now.localtime.strftime("%F %T") }.to_json
      puts "Sending message - #{message}"
      sqs.send_message(queue_url: queue_url, message_body: message)
      sleep(sleep_period)
    end
  end

  def start
    queue = create_std_q
    puts "Queue URL :: #{queue.queue_url}"
    publish_messages(queue.queue_url)
  end
end
