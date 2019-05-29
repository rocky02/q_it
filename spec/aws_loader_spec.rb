# Dummy class for testing module
class ModuleTest
  include AwsLoader
end

RSpec.describe AwsLoader do

  let (:mod_test) { ModuleTest.new }

  context 'aws.yml file' do    
    context '#configure_aws_file' do
      it 'should call #configure_aws_file' do
        stub_const('AwsLoader::AWS_PATH', nil)
        allow(File).to receive(:exists?).with(AwsLoader::AWS_PATH).and_return(false)
        expect(mod_test).to receive(:generate_aws_yml_file)
        mod_test.configure_aws_file
      end
    end

    context 'no aws key values' do
      it 'should log error for no values for the aws config keys in it' do
        stub_const('AwsLoader::AWS_PATH', File.join(Application.root, 'aws.yml'))
        allow(File).to receive(:exists?).with(AwsLoader::AWS_PATH).and_return(true)
        allow(File).to receive(:read).with(AwsLoader::AWS_PATH).and_return({'aws' => {"access_key_id"=>"", "secret_access_key"=>"", "region"=>""}})
        allow(YAML).to receive(:load).and_return({ 'aws' => { "access_key_id"=>"", "secret_access_key"=>"", "region"=>"" } })
        expect{ mod_test.configure_aws_file }.to raise_error(SystemExit)
      end
    end

    context 'aws.yml exists' do 
      it 'should not generate aws.yml file' do
        stub_const('AwsLoader::AWS_PATH', File.join(Application.root, 'aws.yml'))
        allow(File).to receive(:exists?).with(AwsLoader::AWS_PATH).and_return(true)
        expect(mod_test).to_not receive(:generate_aws_yml_file)
        mod_test.configure_aws_file
      end
    end

    context '#generate_aws_yml_file' do
      let (:file) { double('file') }
      
      it 'should generate aws.yml file write the expected keys' do
        stub_const('AwsLoader::AWS_PATH', File.join(Application.root, 'aws.yml'))
        sample_aws = {"aws"=>{"access_key_id"=>"", "secret_access_key"=>"", "region"=>""}}.to_yaml
        expect(File).to receive(:open).with(AwsLoader::AWS_PATH, 'w').and_yield(file)
        expect(file).to receive(:puts).with(sample_aws)
        mod_test.generate_aws_yml_file
      end
    end
  end
end
