.PHONY: clean init plan apply destroy format validate

clean:
	@rm -rf .terraform

fmt:
	@terraform fmt --recursive
	
validate:
	@terraform validate .

init:
	@terraform init -backend-config=backend.tfvars

plan: init 
	@terraform plan --var-file=terraform.tfvars -detailed-exitcode

apply: init 
	@terraform apply --var-file=terraform.tfvars

output:
	@terraform output --json -no-color

destroy: init
	@terraform destroy --var-file=terraform.tfvars
