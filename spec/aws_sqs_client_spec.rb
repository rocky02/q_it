RSpec.describe AwsSQSClient do
  
  let (:aws_sqs_client) { AwsSQSClient.new }

  before do
    stub_const('AwsLoader::AWS', {"access_key_id"=>"access_key", "secret_access_key"=>"secret_access_key", "region"=>"ap-south-1"})
  end

  it 'should create an instance of the AWS SQS Client' do
    expect(aws_sqs_client.client).to be_instance_of(Aws::SQS::Client)
  end
end
