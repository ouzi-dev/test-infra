.PHONY: clean init plan apply destroy format validate bootstrap-init bootstrap-plan bootstrap-apply bootstrap-destroy

ifndef ENV
$(error ENV is not set)
endif

# Get OS
UNAME := $(shell uname)

# Credstash version and dowload locations
CREDSTASH_VERSION := 0.4.0
CREDSTASH_DOWNLOAD_LINUX_URL := https://github.com/sspinc/terraform-provider-credstash/releases/download/$(CREDSTASH_VERSION)/terraform-provider-credstash_linux_amd64
CREDSTASH_DOWNLOAD_DARWIN_URL := https://github.com/sspinc/terraform-provider-credstash/releases/download/$(CREDSTASH_VERSION)/terraform-provider-credstash_darwin_amd64
CREDSTASH_FILEPATH := ~/.terraform.d/plugins/terraform-provider-credstash_v$(CREDSTASH_VERSION)

setup:
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
	@cd bootstrap; terraform fmt --recursive
	@cd env/$(ENV); terraform fmt --recursive
	
validate:
	@terraform validate .

init:
	@terraform init -backend-config=env/$(ENV)/backend.tfvars

plan: init 
	@terraform plan --var-file=env/$(ENV)/terraform.tfvars

apply: init 
	@terraform apply --var-file=env/$(ENV)/terraform.tfvars

output:
	@ENV=$(ENV) $(MAKE) init > /dev/null 2>&1
	@terraform output --json -no-color

destroy: init
	@terraform destroy --var-file=env/$(ENV)/terraform.tfvars

bootstrap-init:
	@cd bootstrap; terraform init

bootstrap-plan: bootstrap-init
	@cd bootstrap; terraform plan 

bootstrap-apply: bootstrap-init
	@cd bootstrap; terraform apply

bootstrap-destroy: bootstrap-init
	@cd bootstrap; terraform destroy

bootstrap: bootstrap-apply

get-kubeconfig:
	@ENV=$(ENV) $(MAKE) init > /dev/null 2>&1
	$(eval NAME=$(shell ENV=$(ENV) $(MAKE) output | jq .name.value))
	$(eval REGION=$(shell ENV=$(ENV) $(MAKE) output | jq .region.value))
	gcloud container clusters get-credentials $(NAME) --region=$(REGION)