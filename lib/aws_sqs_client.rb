class AwsSQSClient

  attr_reader :client
  
  def initialize 
    creds = Aws::Credentials.new(AwsLoader::AWS["access_key_id"], AwsLoader::AWS["secret_access_key"])
    @client = Aws::SQS::Client.new(region: AwsLoader::AWS["region"], credentials: creds)
  end
end
