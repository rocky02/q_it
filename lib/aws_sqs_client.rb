class AwsSQSClient

  attr_reader :client
  
  def initialize 
    creds = Aws::Credentials.new(AWS["access_key_id"], AWS["secret_access_key"])
    @client = Aws::SQS::Client.new(region: AWS["region"], credentials: creds)
  end
end
