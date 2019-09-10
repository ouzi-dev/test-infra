.PHONY: clean init plan apply destroy format validate bootstrap-init bootstrap-plan bootstrap-apply bootstrap-destroy

# Get current directory
DIR := ${CURDIR}

# Credstash version and dowload locations
CREDSTASH_VERSION := 0.4.0
CREDSTASH_DOWNLOAD_DARWIN_URL := https://github.com/sspinc/terraform-provider-credstash/releases/download/$(CREDSTASH_VERSION)/terraform-provider-credstash_darwin_amd64
CREDSTASH_FILEPATH := ~/.terraform.d/plugins/terraform-provider-credstash_v$(CREDSTASH_VERSION)

GOOGLE_APPLICATION_CREDENTIALS_PATH := $(DIR)/.terraform-account.json

setup: get-google-service-account
	@mkdir -p ~/.terraform.d/plugins
	@curl -L "$(CREDSTASH_DOWNLOAD_DARWIN_URL)" -o $(CREDSTASH_FILEPATH) -z $(CREDSTASH_FILEPATH)
	@chmod +x ~/.terraform.d/plugins/terraform-provider-credstash_v$(CREDSTASH_VERSION)

clean:
	@rm -rf .terraform

fmt:
	@terraform fmt --recursive
	
validate:
	@terraform validate .

init: get-google-service-account
	@terraform init -backend-config=backend.tfvars  -backend-config=credentials=$(GOOGLE_APPLICATION_CREDENTIALS_PATH) 
	
plan: init 
	@terraform plan --var-file=terraform.tfvars  -detailed-exitcode -var google_credentials_file_path=$(GOOGLE_APPLICATION_CREDENTIALS_PATH) 

apply: init 
	@terraform apply --var-file=terraform.tfvars -var google_credentials_file_path=$(GOOGLE_APPLICATION_CREDENTIALS_PATH) 

output:
	@$(MAKE) init > /dev/null 2>&1
	@terraform output --json -no-color

destroy: init
	@terraform destroy --var-file=terraform.tfvars -var google_credentials_file_path=$(GOOGLE_APPLICATION_CREDENTIALS_PATH)

get-cluster-credentials:
	@$(MAKE) init > /dev/null 2>&1
	$(eval NAME=$(shell $(MAKE) output | jq .name.value))
	$(eval REGION=$(shell $(MAKE) output | jq .region.value))
	gcloud container clusters get-credentials $(NAME) --region=$(REGION)

get-google-service-account: 
	@credstash get ouzidev-testinfra-terraform-svcaccount > $(GOOGLE_APPLICATION_CREDENTIALS_PATH)