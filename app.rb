require 'rubygems'
require 'bundler/setup'

require 'byebug'

require_relative 'load_aws'
require_relative 'publisher.rb'

options = ARGV
if options[0].nil?
  puts "You must enter a queue name."
  return 
end
puts "Starting Queue Service..."
sqs_pub = Publisher.new()    
queue = sqs_pub.create_std_q(options[0])
sqs_pub.publish_messages(queue.queue_url, options)
