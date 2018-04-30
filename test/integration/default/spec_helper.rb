require 'aws-sdk'
require 'json'

module EC2Helper
  # Source: https://gist.github.com/tom-butler/dd85c32f1db49246f2f6ec84f555281f
  def self.get_ec2_instance_id_from_tag_name(name, region)
    # Filter the ec2 instances for name and state pending or running
    ec2 = Aws::EC2::Resource.new(region: region)
    instances = ec2.instances({ filters: [
      { name: "tag:Name", values: [name] },
      { name: "instance-state-name", values: ["pending", "running"] }
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

class TFVarsHelper
  def self.get_tfvars_from_json_file(path)
    JSON.parse(File.read(path))
  end
end
