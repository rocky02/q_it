require 'aws-sdk-sqs'
require_relative 'load_aws'

class Publisher
  
  attr_reader :sqs

  def initialize
    creds = Aws::Credentials.new(AWS["access_key_id"], AWS["secret_access_key"])
    @sqs = Aws::SQS::Client.new(region: AWS["region"], credentials: creds)
  end

  # For Standard Queue
  def create_std_q(queue_name)
    std_queue = sqs.create_queue(queue_name: queue_name)
  end

  def valid_sleep_period?(sleep_period)
    max_sleep_period = /\A([5-9]|1\d{1}|20)\z/
    !sleep_period.nil? && sleep_period.match(max_sleep_period)
  end

  def publish_messages(queue_url, options=[])
    sleep_period = valid_sleep_period?(options[1]) ? options[1].to_i : 5
    
    0.upto(Float::INFINITY) do |count|
      message = { count: count, timestamp: Time.now.strftime("%GW%V%uT%H%M%S%L%z") }.to_json
      puts "Sending message - #{message}"
      sqs.send_message(queue_url: queue_url, message_body: message)
      sleep(sleep_period)
    end
  end
end
