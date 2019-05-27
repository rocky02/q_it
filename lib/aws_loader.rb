require 'yaml'
require_relative '../config/application'
module AwsLoader
  
  AWS_PATH = File.join(Application.root, 'config/aws.yml')
  AWS = YAML.load(File.read(AWS_PATH))["aws"] if File.exists?(AWS_PATH)
  
  def generate_aws_yml_file
    sample_aws = {"aws"=>{"access_key_id"=>"", "secret_access_key"=>"", "region"=>""}}
    File.open(AWS_PATH, 'w') do |file|
      file.puts sample_aws.to_yaml
    end
  end

  def configure_aws_file
    begin
      if File.exists?(AWS_PATH)
        aws = YAML.load(File.read(AWS_PATH))["aws"]
        if aws.values.any?(&:empty?)
          Application.log.error "Fill in the appropriate values for the aws.yml file"
          exit 1
        end 
      else
        Application.log.warn "No `aws.yml` file present!"
        generate_aws_yml_file
        Application.log.warn "Created file and set the appropriate values!"
        exit 1
      end
    rescue => e
      Application.log.error "Exception with aws.yml file #{e.inspect}"
    end
  end
end
