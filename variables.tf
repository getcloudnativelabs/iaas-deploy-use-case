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
  description = "Name of your EC2 key pair."
}
