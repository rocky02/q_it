require 'aws-sdk-sqs'
require_relative 'load_aws'

class Publisher
  
  attr_reader :sqs, :sleep_period, :queue_name

  def initialize(options)
    creds = Aws::Credentials.new(AWS["access_key_id"], AWS["secret_access_key"])
    @sqs = Aws::SQS::Client.new(region: AWS["region"], credentials: creds)
    @sleep_period = valid_sleep_period?(options[1]) ? options[1].to_i : 5
    @queue_name = options[0]
  end

  # For Standard Queue
  def create_std_q
    sqs.create_queue(queue_name: queue_name)
  end

  def valid_sleep_period?(sleep_period)
    max_sleep_period = /\A([5-9]|1\d{1}|20)\z/
    !sleep_period.nil? && sleep_period.match(max_sleep_period)
  end

  def publish_messages(queue_url)
    0.upto(Float::INFINITY) do |count|
      message = { count: count, timestamp: Time.now.strftime("%GW%V%uT%H%M%S") }.to_json
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
