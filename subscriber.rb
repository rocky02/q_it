
require 'aws-sdk-sqs'
require 'byebug'
require_relative 'load_aws'

class Subscriber
  
  ACCESS_KEY_ID = AWS["access_key_id"]
  SECRET_ACCESS_KEY = AWS["secret_access_key"]
  REGION = AWS["region"]

  attr_reader :sqs

  def initialize
    creds = Aws::Credentials.new(ACCESS_KEY_ID, SECRET_ACCESS_KEY)
    @sqs = Aws::SQS::Client.new(region: REGION, credentials: creds)
  end

# Todo: URL validation
  def read_queue(options=[])
    queue_url = options[0]
    max_number_of_messages = options[1].nil? ? 10 : options[1]
    wait_time_seconds = options[2].nil? ? 10 : options[2]
    
    result = sqs.receive_message(queue_url: queue_url, max_number_of_messages: max_number_of_messages, wait_time_seconds: wait_time_seconds)
    
    result.messages.each do |msg|
      puts "-"*50
      puts "Message_id: #{msg.message_id}"
      puts "Receipt Handle: #{msg.receipt_handle}"
      puts "Message Body: #{msg.body}"
      sqs.delete_message(queue_url: queue_url, receipt_handle: msg.receipt_handle)
    end
  end
end

begin
  options = ARGV
  if options[0].nil?
    puts "You must enter the queue url."
    return
  end
  puts "Starting Subscriber service..."
  subscriber = Subscriber.new
  subscriber.read_queue(options)
rescue Exception => e
  puts "There is an exception in the Subscriber service #{e.inspect}"
end
