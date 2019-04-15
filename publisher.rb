require 'aws-sdk-sqs'

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

  def publish_messages(queue_url, options=[])
    delay_seconds = options[1].nil? ? 5 : options[1]
    0.upto(Float::INFINITY) do |count|
      message = { count: count, timestamp: Time.now.strftime("%GW%V%uT%H%M%S%L%z") }.to_json
      puts "Sending message - #{message}"
      sqs.send_message(queue_url: queue_url, message_body: message, delay_seconds: delay_seconds)
      sleep(5)
    end
  end
end