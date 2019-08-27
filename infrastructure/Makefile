.PHONY: clean init plan apply destroy format validate bootstrap-init bootstrap-plan bootstrap-apply bootstrap-destroy

ifndef ENV
$(error ENV is not set)
endif

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