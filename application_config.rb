require 'aws-sdk-sqs'
require 'colorize'
Dir.glob(File.join('lib', '**', '*.rb')).each { |file| require_relative "#{file}" }