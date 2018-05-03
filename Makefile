NAMESPACE := "default"
ROOT := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

default: init test

all: init test plan deploy smoke-test describe

.PHONY: init
## Initialize project.
init:
	# Install Gemfile bundles
	@bundle install --path vendor/bundle --jobs=2
	# Install Git pre-commit hooks
	@pre-commit install --overwrite
	# Install Terraform working directory
	@terraform init -input=false

.PHONY: test
## Run infrastructure (integration) tests (before deployment).
test:
	# See https://github.com/hashicorp/terraform/issues/17655
	@TF_WARN_OUTPUT_ERRORS=1 VARS_JSON_FILE=$(ROOT)/terraform-testing.tfvars.json bundle exec kitchen test --destroy=always

.PHONY: plan
## Plan infrastructure.
plan:
	@TF_IN_AUTOMATION=1 TF_WORKSPACE=$(NAMESPACE) terraform plan -input=false -out=tfplan | tee tfplan.txt

.PHONY: deploy
## Auto-deploy infrastructure.
deploy:
	@TF_IN_AUTOMATION=1 TF_WORKSPACE=$(NAMESPACE) terraform apply -auto-approve -input=false tfplan

.PHONY: smoke-test
## Run infrastructure (smoke) tests (after deployment).
smoke-test:
	@VARS_JSON_FILE=$(ROOT)/terraform.tfvars.json bundle exec rspec -c -f documentation --default-path $(ROOT) -P test/integration/**/*_spec.rb

.PHONY: describe
## Describe infrastructure.
describe:
	@TF_IN_AUTOMATION=1 TF_WORKSPACE=$(NAMESPACE) terraform output -json | tee outputs.json

.PHONY: destroy
## Auto-destroy infrastructure.
destroy:
	@TF_IN_AUTOMATION=1 TF_WORKSPACE=$(NAMESPACE) terraform destroy -auto-approve
