# iaas-deploy-use-case

A simple IaaS deployment use-case using Terraform.

- An EC2 instance
- An EC2 Security Group

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

Assuming you don't alter the settings in the next step, the credentials under *testing* will be used when testing deployments. Those under *default* will be used in all non-testing scenarios.

3. Review the settings in `terraform-testing.tfvars.json`. These will apply only in testing:

```
{
  "aws_profile": "testing",
  "aws_region": "eu-west-1",
  ...
```

4. Review the settings in `terraform.tfvars` (see `variables.tf` for supported settings and defaults):

```
{
  "aws_profile": "default",
  "aws_region": "eu-west-1",
  ...
```

The settings in `terraform.tfvars` declare user-provided settings and would typically be created on-the-fly.

5. Run tests and deploy the infrastructure:

```
make all
```

6. Destroy the infrastructure:

```
make destroy
```
