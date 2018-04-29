require 'awspec'
require_relative './spec_helper'

describe ec2(EC2Helper.get_id_from_name('example')) do
  it { should exist }
  it { should be_running }
  its(:image_id) { should eq 'ami-ed100689' }
  its(:instance_type) { should eq 't2.micro' }
  it { should have_tag('Name').value('example') }
  it { should have_security_group('example-sg') }
  it { should belong_to_vpc('default') }
  it { should belong_to_subnet('default') }
end
