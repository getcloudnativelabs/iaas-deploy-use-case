require 'awspec'
require_relative './spec_helper'

vars = VarsHelper.new

describe 'Deployment' do
  describe security_group(vars.get('meta_namespace') + '-' + vars.get('meta_name') + '-sg') do
    it { should exist }
    it { should have_tag('Name').value(vars.get('meta_namespace') + '-' + vars.get('meta_name') + '-sg') }
    it { should have_tag('Owner_Department').value(vars.get('meta_owner_department')) }
    it { should have_tag('Owner_Email').value(vars.get('meta_owner_email')) }
    it { should have_tag('Owner_Name').value(vars.get('meta_owner_name')) }
  end

  describe ec2(EC2Helper.get_ec2_instance_id_from_tag_name(vars.get('meta_namespace') + '-' + vars.get('meta_name'), vars.get('aws_region'))) do
    it { should exist }
    it { should be_running }

    it { should have_tag('Name').value(vars.get('meta_namespace') + '-' + vars.get('meta_name')) }
    it { should have_tag('Owner_Department').value(vars.get('meta_owner_department')) }
    it { should have_tag('Owner_Email').value(vars.get('meta_owner_email')) }
    it { should have_tag('Owner_Name').value(vars.get('meta_owner_name')) }
    it { should have_security_group(vars.get('meta_namespace') + '-' + vars.get('meta_name') + '-sg') }

    its(:instance_type) { should eq vars.get('ec2_instance_type') }
    its('image.image_owner_alias') { should eq 'amazon' }
    its('subnet.default_for_az') { should eq true }
    its('vpc.is_default') { should eq true }
  end
end
