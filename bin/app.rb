require 'rubygems'
require 'bundler/setup'
require_relative '../application_config'
class App
  include AwsLoader

  SERVICES = ['publish', 'subscribe']

  def run_service(options)
    service = options.delete_at(0)
    case service
    when 'publish'
      Publisher.validate(options)
      publisher = Publisher.new(options)
      publisher.start
    when 'subscribe'
      Subscriber.validate(options)
      subscriber = Subscriber.new(options)
      subscriber.start
    else
      raise QItNoServiceError, "Invalid service name. Try #{SERVICES.join(', ')}.".colorize(:red) if (service.nil? || !SERVICES.include?(service.downcase))
    end  
  end
end

# Beginning of execution of App.
options = ARGV
service = options[0]
raise QItArgumentError, "Wrong Arguments. Check documentation on how to run the service.".colorize(:red) if options.length !=3

begin
  app = App.new
  app.configure_aws_file
  puts "Starting Queue Service...".colorize(:cyan)
  app.run_service(options)
rescue ArgumentError => e
  QIt.log.error "There is an exception in the #{service} service #{e.inspect}".colorize(:red)
end
