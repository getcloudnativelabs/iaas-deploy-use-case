provider "aws" {
  region                  = "${var.aws_region}"
  shared_credentials_file = "${var.aws_shared_credentials_file}"
  profile                 = "${var.aws_profile}"
}

##################################################################
# Data sources to get VPC, subnet, security group and AMI details
##################################################################
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default.id}"
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}

module "ec2_security_group" {
  source = "github.com/getcloudnativelabs/iaas-blueprint-components//aws/ec2-security-group"

  name   = "${var.meta_name}-sg"
  vpc_id = "${data.aws_vpc.default.id}"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp", "http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
}

module "ec2_instance" {
  source = "github.com/getcloudnativelabs/iaas-blueprint-components//aws/ec2-instance"

  name                        = "${var.meta_name}"
  ami                         = "${data.aws_ami.amazon_linux.id}"
  instance_type               = "${var.ec2_instance_type}"
  subnet_id                   = "${element(data.aws_subnet_ids.all.ids, 0)}"
  vpc_security_group_ids      = ["${module.ec2_security_group.this_security_group_id}"]
  associate_public_ip_address = true
  key_name                    = "${var.ec2_key_name}"

  tags {
    Name             = "${var.meta_name}"
    Owner_Name       = "${var.meta_owner_name}"
    Owner_Email      = "${var.meta_owner_email}"
    Owner_Department = "${var.meta_owner_department}"
  }
}
