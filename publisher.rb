require 'aws-sdk-sqs'
class Publisher
  # Note: You can store the values of the aws access keys and region list in a config file (json) 
  # from where you can get the values into the constants.
  ACCESS_KEY_ID = #<your access key id>
  SECRET_ACCESS_KEY = #<your secret access key>
  REGION = #<your aws account region>

  attr_accessor :sqs

  def initialize
    creds = Aws::Credentials.new(ACCESS_KEY_ID, SECRET_ACCESS_KEY)
    @sqs = Aws::SQS::Client.new(region: REGION, credentials: creds)
  end

  # For Standard Queue
  def create_std_q queue_name
    std_queue = sqs.create_queue(queue_name: queue_name)
  end

  # For FIFO Queue
  def create_fifo_q queue_name
    queue_name = queue_name.split('.')[0]
    fifo_queue = sqs.create_queue(queue_name: "#{queue_name}.fifo", attributes: { "FifoQueue": "true", "ContentBasedDeduplication": "true"})
  end

  def publish_messages queue
    queue_url = queue.queue_url
    0.upto(Float::INFINITY) do |count|
      timestamp = Time.now.strftime("%GW%V%uT%H%M%S%L%z")
      message = { count: count, timestamp: timestamp }.to_json
      puts "Message generated - #{message}"
      puts "Sending message..."
      if fifo? queue_url
        sqs.send_message(queue_url: queue_url, message_body: message, message_group_id: timestamp)
      else
        sqs.send_message(queue_url: queue_url, message_body: message)
      end
    end
  end

  def fifo? queue_url
    queue_url.split('.')[-1] == 'fifo'
  end
end

puts "Starting Queue Service..."
sqs_pub = Publisher.new()
puts "Enter the name of the queue"
queue_name = gets.chomp
puts "enter 'fifo' if you want the queue to be FIFO else leave blank"
queue_type = gets.chomp
queue = if queue_type == 'fifo'
sqs_pub.create_fifo_q(queue_name)
else
sqs_pub.create_std_q(queue_name)
end
sqs_pub.publish_messages(queue)