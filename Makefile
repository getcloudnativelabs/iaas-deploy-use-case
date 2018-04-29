default: plan

all: deploy

.PHONY: plan
plan: ## Plan infrastructure changes.
	terraform plan

.PHONY: deploy
deploy: ## Auto-deploy infrastructure changes.
	terraform apply -auto-approve

.PHONY: destroy
destroy: ## Auto-destroy infrastructure changes.
	terraform destroy -auto-approve
