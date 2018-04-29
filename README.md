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

1. Install dependencies

```
bundle install
```

Requires the Ruby `bundler` gem, which can be installed via `sudo gem install bundler`.

2. Add the AWS credentials for your *default* and *testing* environments in `~/.aws/credentials`:

```
[default]
aws_access_key_id={YOUR_ACCESS_KEY_ID}
aws_secret_access_key={YOUR_SECRET_ACCESS_KEY}

[testing]
aws_access_key_id={YOUR_TESTING_ACCESS_KEY_ID}
aws_secret_access_key={YOUR_TESTING_SECRET_ACCESS_KEY}
```

The `default` credentials will be used for regular deployments, whereas the *testing* credentials will be used for deployment testing purposes only.

3. Set the AWS region for your testing activities in `terraform-testing.tfvars` and `.env`, respectively:

```
aws_profile = "staging"
aws_region  = "{YOUR_REGION}"
```

```
export AWS_DEFAULT_REGION={YOUR_REGION}
```

The settings in `.terraform-testing.tfvars` will be used when executing test deployments, whereas those in `.env` will be used when validating deployed infrastructure components.

4. Provide your settings in `terraform.tfvars` (see `variables.tf` for supported options):

```
ec2_key_name = "{YOUR_EC2_KEY_NAME}"
```

The settings in `terraform.tfvars` define user-provided input.

5. Deploy the infrastructure:

```
make all
```

6. Destroy the infrastructure:

```
make destroy
```