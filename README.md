# iaas-deploy-use-case

A simple IaaS deployment use-case using Terraform.

- An EC2 instance (*t2.micro*)
- An EC2 Security Group
    - Ingress: *SSH*, *HTTP*, *ICMP* from *All*
    - Egress: *All*

## Prerequisites

- An AWS AMI User
- An AWS EC2 Key Pair

## How-To

1. Provide your AWS Credentials in `~/.aws/credentials`

```
[default]
aws_access_key_id={YOUR_ACCESS_KEY_ID}
aws_secret_access_key={YOUR_SECRET_ACCESS_KEY}
```

2. Provide your settings in `terraform.tfvars` (see `variables.tf` for supported options)

```
ec2_key_name = "YOUR_AWS_EC2_KEY_NAME"
```

3. Deploy the infrastructure

```
make all
```

4. Destroy the infrastructure

```
make destroy
```