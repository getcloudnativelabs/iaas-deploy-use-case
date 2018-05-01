ROOT := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

default: init test

all: init test deploy

.PHONY: init
## Initialize Terraform dependencies.
init:
	# Install Gemfile bundles
	bundle install --path vendor/bundle
	# Install Git pre-commit hooks
	pre-commit install --overwrite
	# Install Terraform working directory
	terraform init

.PHONY: test
## Test infrastructure deployments.
test:
	# See https://github.com/hashicorp/terraform/issues/17655
	TF_WARN_OUTPUT_ERRORS=1 VARS_JSON_FILE=$(ROOT)/terraform-testing.tfvars.json bundle exec kitchen test --destroy=always

.PHONY: deploy
## Auto-deploy infrastructure changes.
deploy:
	terraform apply -auto-approve

.PHONY: destroy
## Auto-destroy infrastructure changes.
destroy:
	terraform destroy -auto-approve

.PHONY: plan
## Plan infrastructure changes.
plan:
	terraform plan
