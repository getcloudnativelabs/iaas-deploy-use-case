default: test

all: test deploy

.PHONY: test
test: ## Test infrastructure deployments.
	env $(shell cat .env | xargs) kitchen verify

.PHONY: deploy
deploy: ## Auto-deploy infrastructure changes.
	terraform apply -auto-approve

.PHONY: destroy
destroy: ## Auto-destroy infrastructure changes.
	terraform destroy -auto-approve

.PHONY: plan
plan: ## Plan infrastructure changes.
	terraform plan
