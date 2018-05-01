require 'aws-sdk'
require 'json'

module EC2Helper
  def self.get_ec2_instance_id_from_tag_name(name, region)
    ENV['AWS_REGION'] = region

    # Filter the ec2 instances for name and state pending or running
    resource = Aws::EC2::Resource.new
    instances = resource.instances({ filters: [
      { name: 'tag:Name', values: [name] },
      { name: 'instance-state-name', values: ['pending', 'running'] }
    ]}).map(&:id)

    if instances.count == 1
      instances[0]
    elsif instances.count == 0
      STDERR.puts "Error: '#{name}' Instance not found"
      []
    else
      STDERR.puts "Error: more than one running instance exists with name '#{name}'"
      instances
    end
  end
end

class VarsHelper
  @vars = Hash.new

  def self.load_vars_from_json_file(path)
    JSON.parse(File.read(path))
  end

  def initialize(path = ENV['VARS_JSON_FILE'])
    @vars = self.class.load_vars_from_json_file(path)
  end

  def get(name)
    @vars[name]
  end
end
