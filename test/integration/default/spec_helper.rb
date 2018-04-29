require 'aws-sdk'

module EC2Helper
  def self.get_id_from_name(name)
    # Filter the ec2 instances for name and state pending or running
    ec2 = Aws::EC2::Resource.new(region: ENV['AWS_DEFAULT_REGION'])    
    instances = ec2.instances({ filters: [
      { name: "tag:Name", values: [name] },
      { name: "instance-state-name", values: [ "pending", "running"] }
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
