require 'aws-sdk-sqs'
Dir.glob(File.join('lib', '**', '*.rb')).each { |file| require_relative "#{file}" }