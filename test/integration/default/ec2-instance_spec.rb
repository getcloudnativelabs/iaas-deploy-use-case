require 'awspec'
require_relative './spec_helper'

tfvars_json_file = File.expand_path('../../../terraform-testing.tfvars.json', File.dirname(__FILE__))
tfvars = TFVarsHelper.get_tfvars_from_json_file(tfvars_json_file)

describe ec2(EC2Helper.get_ec2_instance_id_from_tag_name(tfvars["meta_name"], tfvars["aws_region"])) do
  it { should exist }
  it { should be_running }

  it { should have_tag('Name').value(tfvars["meta_name"]) }
  it { should have_tag('Owner_Department').value(tfvars["meta_owner_department"]) }
  it { should have_tag('Owner_Email').value(tfvars["meta_owner_email"]) }
  it { should have_tag('Owner_Name').value(tfvars["meta_owner_name"]) }
  it { should have_security_group(tfvars["meta_name"] + '-sg') }

  its(:instance_type) { should eq tfvars["ec2_instance_type"] }
  its('image.image_owner_alias') { should eq 'amazon' }
  its('subnet.default_for_az') { should eq true }
  its('vpc.is_default') { should eq true }
end
