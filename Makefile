ROOT := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

default: init test

all: init test deploy smoke-test

.PHONY: init
## Initialize project.
init:
	# Install Gemfile bundles
	bundle install --path vendor/bundle --jobs=2
	# Install Git pre-commit hooks
	pre-commit install --overwrite
	# Install Terraform working directory
	terraform init

.PHONY: test
## Run infrastructure (integration) tests (before deployment).
test:
	# See https://github.com/hashicorp/terraform/issues/17655
	TF_WARN_OUTPUT_ERRORS=1 VARS_JSON_FILE=$(ROOT)/terraform-testing.tfvars.json bundle exec kitchen test --destroy=always

.PHONY: smoke-test
## Run infrastructure (smoke) tests (after deployment).
smoke-test:
	VARS_JSON_FILE=$(ROOT)/terraform.tfvars.json rspec -c -f documentation --default-path $(ROOT) -P test/integration/**/*_spec.rb

.PHONY: deploy
## Auto-deploy infrastructure.
deploy:
	terraform apply -auto-approve

.PHONY: destroy
## Auto-destroy infrastructure.
destroy:
	terraform destroy -auto-approve

.PHONY: plan
## Plan infrastructure.
plan:
	terraform plan
