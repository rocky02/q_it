# Dummy class for testing module
class ModuleTest
  include AwsLoader
end

RSpec.describe AwsLoader do

  let (:mod_test) { ModuleTest.new }
  let (:logger) { Logger.new(File.join(QIt.root, 'log/q_it.log')) }

  context 'aws.yml file' do    
    context '#configure_aws_file' do
      it 'should return false for aws.yml file check and call #configure_aws_file and create a new .yml file' do
        stub_const('AwsLoader::AWS_PATH', nil)
        allow(File).to receive(:exists?).and_return(false)
        expect(mod_test).to receive(:generate_aws_yml_file)
        mod_test.configure_aws_file
      end
      
      it 'should return true for aws.yml file check and check for aws config values in the file' do
        stub_const('AwsLoader::AWS_PATH', File.join(QIt.root, 'aws.yml'))
        stub_const('AwsLoader::AWS', {"access_key_id"=>"", "secret_access_key"=>"", "region"=>""})
        allow(File).to receive(:exists?).with(AwsLoader::AWS_PATH).and_return(true)
        expect(mod_test).to_not receive(:generate_aws_yml_file)
        mod_test.configure_aws_file
      end
    end
  end
end
