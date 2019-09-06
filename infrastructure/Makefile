.PHONY: clean init plan apply destroy format validate bootstrap-init bootstrap-plan bootstrap-apply bootstrap-destroy

# Get current directory
DIR := ${CURDIR}

# Get OS
UNAME := $(shell uname)

# Credstash version and dowload locations
CREDSTASH_VERSION := 0.4.0
CREDSTASH_DOWNLOAD_LINUX_URL := https://github.com/sspinc/terraform-provider-credstash/releases/download/$(CREDSTASH_VERSION)/terraform-provider-credstash_linux_amd64
CREDSTASH_DOWNLOAD_DARWIN_URL := https://github.com/sspinc/terraform-provider-credstash/releases/download/$(CREDSTASH_VERSION)/terraform-provider-credstash_darwin_amd64
CREDSTASH_FILEPATH := ~/.terraform.d/plugins/terraform-provider-credstash_v$(CREDSTASH_VERSION)

GOOGLE_APPLICATION_CREDENTIALS_PATH := $(DIR)/.terraform-account.json

setup: get-google-service-account
	@mkdir -p ~/.terraform.d/plugins
ifeq ($(UNAME),Linux)
	curl -L "$(CREDSTASH_DOWNLOAD_LINUX_URL)" -o $(CREDSTASH_FILEPATH) -z $(CREDSTASH_FILEPATH)
endif
ifeq ($(UNAME),Darwin)
	curl -L "$(CREDSTASH_DOWNLOAD_DARWIN_URL)" -o $(CREDSTASH_FILEPATH) -z $(CREDSTASH_FILEPATH)
endif
	chmod +x ~/.terraform.d/plugins/terraform-provider-credstash_v$(CREDSTASH_VERSION)

clean:
	@rm -rf .terraform

fmt:
	@terraform fmt --recursive
	
validate:
	@terraform validate .

init: get-google-service-account
	@terraform init -backend-config=backend.tfvars
	
plan: init 
	@export GOOGLE_APPLICATION_CREDENTIALS=$(GOOGLE_APPLICATION_CREDENTIALS_PATH) && terraform plan --var-file=terraform.tfvars -detailed-exitcode

apply: init 
	@export GOOGLE_APPLICATION_CREDENTIALS=$(GOOGLE_APPLICATION_CREDENTIALS_PATH) && terraform apply --var-file=terraform.tfvars

output:
	@$(MAKE) init > /dev/null 2>&1
	@terraform output --json -no-color

destroy: init
	@export GOOGLE_APPLICATION_CREDENTIALS=$(GOOGLE_APPLICATION_CREDENTIALS_PATH) && terraform destroy --var-file=terraform.tfvars

get-cluster-credentials:
	@$(MAKE) init > /dev/null 2>&1
	$(eval NAME=$(shell $(MAKE) output | jq .name.value))
	$(eval REGION=$(shell $(MAKE) output | jq .region.value))
	gcloud container clusters get-credentials $(NAME) --region=$(REGION)

get-google-service-account: 
	@$(MAKE) -C bootstrap output | jq -r .service_account_key.value | base64 -D > $(GOOGLE_APPLICATION_CREDENTIALS_PATH)