require 'yaml'

def generate_aws_yml_file
  sample_aws = {"aws"=>{"access_key_id"=>"", "secret_access_key"=>"", "region"=>""}}
  File.open(File.join(Dir.pwd, 'config/aws.yml'), 'w') do |file|
    file.puts sample_aws.to_yaml
  end
end

begin
  if File.exists?(File.join(Dir.pwd, 'config/aws.yml'))
    AWS = YAML.load(File.read('config/aws.yml'))["aws"]
    if AWS.values.any?(&:empty?)
      puts "Fill in the appropriate values for the aws.yml file"
      exit 1
    end 
  else
    puts "No `aws.yml` file present!"
    generate_aws_yml_file
    puts "Created file and set the appropriate values!"
    exit 1
  end
rescue => e
  puts "Exception with aws.yml file #{e.inspect}"
end
