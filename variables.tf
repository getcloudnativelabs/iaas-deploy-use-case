###########
# METADATA
###########

variable "meta_name" {
  description = "A name describing the deployment."
}

variable "meta_owner_name" {
  description = "The name of the person that owns the deployment."
}

variable "meta_owner_email" {
  description = "The email address of the person that owns the deployment."
}

variable "meta_owner_department" {
  description = "The department the person that owns the deployment belongs to."
}

######
# AWS
######

variable "aws_shared_credentials_file" {
  description = "An absolute path to your AWS shared credentials file."
  default     = "~/.aws/credentials"
}

variable "aws_profile" {
  description = "The name of the AWS profile (configuration block name in the shared credentials file)."
  default     = "default"
}

variable "aws_region" {
  description = "The name of the AWS region."
  default     = "eu-west-1"
}

######
# EC2
######

variable "ec2_key_name" {
  description = "The name of your EC2 key pair."
}

variable "ec2_instance_type" {
  description = "The instance type of the EC2 instance."
  default     = "t2.micro"
}
