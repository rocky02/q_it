require 'rspec'
require_relative '../lib/publisher'

RSpec.describe Subscriber do
  before do
    @sqs = Aws::SQS::Client.new(endpoint: "https://localhost:9324")
  end

  context 'when the Queue name provided is valid' do
    it 'creates a Standard AWS SQS queue and publishes to the queue' do

    end
  end
end