require 'rubygems'
require 'bundler/setup'
require_relative 'publisher.rb'
require_relative 'subscriber.rb'

def run_service(options)
  service = options.delete_at(0)
  
  case service
  when 'publish'
    publisher = Publisher.new(options)
    publisher.start
  when 'subscribe'
    subscriber = Subscriber.new(options)
    subscriber.start
  else
    puts "Invalid service name. Use 'publish' or 'subscribe'."
    exit(1)
  end
end

# Beginning of execution of App.
options = ARGV
service = options[0]
begin
  puts "Starting Queue Service..."
  run_service(options)
rescue Exception => e
  puts "There is an exception in the #{service} service #{e.inspect}"
end
