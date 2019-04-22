require 'rubygems'
require 'bundler/setup'
require_relative 'publisher.rb'
require_relative 'subscriber.rb'
require_relative 'q_it_errors'

SERVICES = ['publish', 'subscribe']

def run_service(service, options)
  if valid_options?(options)
    service = service
    case service
    when 'publish'
      publisher = Publisher.new(options)
      publisher.start
    when 'subscribe'
      subscriber = Subscriber.new(options)
      subscriber.start
    else
      raise QItNoServiceError, "Invalid service name. Try 'publish' or 'subscribe'." if (service.nil? || !SERVICES.include?(service.downcase))
    end
  end
end

def valid_options?(options=[])
  service = options.delete_at(0)

  case service
  when 'publish'
    Publisher.validate(options)
  when 'subscribe'
    Subscriber.validate(options)
  else
    false
  end
end

# Beginning of execution of App.
options = ARGV
service = options[0]
raise QItArgumentError, "Wrong Arguments. Check documentation on how to run the service." if options.length !=3
begin
  puts "Starting Queue Service..."
  run_service(service, options)
rescue ArgumentError => e
  puts "There is an exception in the #{service} service #{e.inspect}"
end
