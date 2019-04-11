# Do not commit this file
# Example of how the YAML file is loaded and can be used.
#
# Run the app as `ruby sample_publisher.rb`
#
require 'aws-sdk-sqs'
require 'byebug'
require File.join(Dir.pwd, 'load_aws.rb')

# THis displays the loaded aws.yml in memory
puts AWS
