default: init test

all: init test deploy

.PHONY: init
## Initialize Terraform dependencies.
init:
	pre-commit install --overwrite
	terraform init

.PHONY: test
## Test infrastructure deployments.
test:
	# See https://github.com/hashicorp/terraform/issues/17655
	TF_WARN_OUTPUT_ERRORS=1 bundle exec kitchen test --destroy=always

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
