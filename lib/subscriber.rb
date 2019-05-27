require File.join(Application.root, 'application_config')

class Subscriber

  attr_reader :sqs, :sleep_period, :queue_url

  def initialize(options)
    @sqs = AwsSQSClient.new.client
    @queue_url = options[0]
    @sleep_period = options[1].to_i
  end

  def self.validate(options)
    raise QItArgumentError, "QItArgumentError :: Incorrect number of arguments. Expected 2 got #{options.count}" if options.count != 2

    valid_sqs_url?(options[0]) && valid_sleep_period?(options[1])
  end
  
  def self.valid_sqs_url?(sqs_url)
    valid_sqs_url_regex = /\A(https:\/\/sqs.)#{AwsLoader::AWS["region"]}.amazonaws.com\/\d{12}\/[^.]+\z/
    
    unless sqs_url.match?(valid_sqs_url_regex)
      raise QItInvalidArgumentError, "QItInvalidArgumentError :: #{self} Invalid SQS URL #{sqs_url}." 
    else
      true
    end    
  end

  def self.valid_sleep_period?(sleep_period)
    max_sleep_period = /\A([3-9]|1[0-5])\z/
    
    unless sleep_period.match?(max_sleep_period)
      raise QItInvalidArgumentError, "QItInvalidArgumentError :: #{self} Invalid sleep period #{sleep_period}. Sleep period range is between 3-15 seconds." 
    else
      true
    end
  end

  def read_queue
    loop do
      result = sqs.receive_message(queue_url: queue_url, max_number_of_messages: 1)
      result.messages.each do |msg|
        puts("*".colorize(:cyan).bold*50)
        puts("*".colorize(:cyan).bold*50)
        puts "Message_id: ".colorize(:yellow).bold + " #{msg.message_id}".colorize(:yellow)
        puts("-".colorize(:cyan)*50)
        puts "Receipt Handle: ".colorize(:blue).bold + " #{msg.receipt_handle}".colorize(:blue)
        puts("-".colorize(:cyan)*50)
        puts "Message Body: ".colorize(:green).bold + " #{msg.body}".colorize(:green)
        puts("-".colorize(:cyan)*50)
        sqs.delete_message(queue_url: queue_url, receipt_handle: msg.receipt_handle)
      end
      sleep(sleep_period)
    end
  end

  def start
    read_queue
  end
end
