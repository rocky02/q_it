require 'aws-sdk-sqs'
require_relative 'load_aws'
require_relative 'aws_sqs_client'
require_relative 'q_it_errors'
class Subscriber

  attr_reader :sqs, :sleep_period, :queue_url

  def initialize(options)
    @sqs = AwsSQSClient.new.client
    @queue_url = valid_sqs_url(options[0])
    @sleep_period = validate_sleep_period(options[1])
  end
  
  def valid_sqs_url(sqs_url)
    valid_sqs_url_regex = /\A(https:\/\/sqs.)#{AWS["region"]}.amazonaws.com\/\d{12}\/[^.]+\z/
    begin
      raise QItNullSQSUrlError, "QItNullSQSUrlError :: #{self} AWS SQS URL cannot be nil." if sqs_url.nil?
      raise QItInvalidSQSUrlError, "QItInvalidSQSUrlError :: #{self} Invalid SQS URL #{sqs_url}." unless sqs_url.match(valid_sqs_url_regex)
      sqs_url
    rescue QItNullSQSUrlError => e
      puts e
      exit(1)
    rescue QItInvalidSQSUrlError => e
      puts e
      exit(1)
    end
  end

  def validate_sleep_period(sleep_period)
    max_sleep_period = /\A([3-9]|1[0-5])\z/
    begin
      raise QItNullSleepTimeError, "QItNullSleepTimeError :: #{self} Sleep period cannot be nil." if sleep_period.nil?
      raise QItArgumentError, "QItArgumentError :: #{self} Invalid sleep period #{sleep_period}. Sleep period range is between 3-15 seconds." unless sleep_period.match(max_sleep_period)
      sleep_period
    rescue QItArgumentError => e
      puts e
      exit(1)
    rescue QItNullSleepTimeError => e
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
