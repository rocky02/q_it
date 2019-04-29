require 'rspec'
require_relative '../lib/subscriber'

RSpec.describe Subscriber do
  before do
    @sqs = Aws::SQS::Client.new(endpoint: "https://localhost:9324")
  end

  context 'when the Queue URL provided is valid' do
    it 'subscribes from a queue' do

    end
  end
end