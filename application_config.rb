require 'aws-sdk-sqs'
require 'byebug'
Dir.glob(File.join('lib', '**', '*.rb')).each { |file| require_relative "#{file}" }