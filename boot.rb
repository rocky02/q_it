require 'aws-sdk-sqs'
require 'logger'
require 'colorize'
require 'byebug'
Dir.glob(File.join('lib', '**', '*.rb')).each { |file| require_relative "#{file}" }
