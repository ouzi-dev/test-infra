.PHONY: clean init plan apply destroy format validate bootstrap-init bootstrap-plan bootstrap-apply bootstrap-destroy

ENV ?= ouzi-unicorn

clean:
	@rm -rf .terraform

fmt:
	@terraform fmt --recursive
	@cd bootstrap; terraform fmt --recursive
	
format: fmt	

validate:
	@terraform validate .

init:
	@terraform init -backend-config=env/$(ENV)/backend.tfvars

plan: init 
	@terraform plan --var-file=env/$(ENV)/terraform.tfvars

apply: init 
	@terraform apply --var-file=env/$(ENV)/terraform.tfvars

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