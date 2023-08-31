#
SHELL := /bin/bash

REPO_BASE_DIR := $(shell git rev-parse --show-toplevel)

.PHONY: help
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@echo "usage: make [target] ..."
	@echo ""
	@echo "Targets for '$(notdir $(CURDIR))':"
	@echo ""
	@awk --posix 'BEGIN {FS = ":.*?## "} /^[[:alpha:][:space:]_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

.venv:
	# creating virtual environment with tooling (jinja, etc)
	@python3 -m venv .venv
	@.venv/bin/pip3 install --upgrade pip wheel setuptools
	@.venv/bin/pip3 install jinja2 j2cli[yaml]

define jinja
	@.venv/bin/j2 --format=env $(1) $(2) -o $(3)
endef


ansible/inventory.ini: ansible/inventory.ini.j2 .venv .env-terraform  ## Create ansible inventory file
	$(call jinja, $<, .env-terraform, $@)

.PHONY: .env-terraform
.env-terraform: .venv
	@> .env-terraform.temp && cd terraform && \
	outputs=$$(terraform output -json); \
	for key in $$(echo $$outputs | jq -r 'keys[]'); do value=$$(echo $$outputs | jq -r --arg key "$$key" '.[$$key].value') && \
	echo "$$key=$$value" >> ../.env-terraform.temp; done && \
	mv ../.env-terraform.temp ../.env-terraform

.PHONY: visualize-tf
visualize-tf: ## Visualize the terraform graph
	@cd terraform && \
	terraform graph | docker run --rm -i --name terraform-graph-beautifier ghcr.io/pcasteran/terraform-graph-beautifier:latest-linux --output-type=cyto-html > terraformgraph.html

.PHONY: ansible-provision
ansible-provision: ansible/inventory.ini ## Provision terraform machines with ansible
	@sudo ansible-playbook -i ansible/inventory.ini -u ansible ansible/playbooks/minimalexample_dockerversion.yml
