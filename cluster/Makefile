# installer url
PROW_INSTALLER_URL = https://github.com/ouzi-dev/prow-installer/releases/download/v1.2.2/prow-installer-v1.2.2.tar.gz

# make sure make fails on shell errors 
# caveat: does not work for the shell function
SHELL = /bin/bash -eo pipefail

# # Get aws keys from credstash 
# PROW_CREDSTASH_AWS_ACCESS_KEY_ID := $(shell credstash --region eu-west-1 get prow-credstash-reader-aws-access-key-id)
# ifneq ($(.SHELLSTATUS),0)
#   $(error Getting Credstash secret failed!)
# endif
# PROW_CREDSTASH_AWS_SECRET_ACCESS_KEY := $(shell credstash --region eu-west-1 get prow-credstash-reader-aws-secret-access-key)
# ifneq ($(.SHELLSTATUS),0)
#   $(error Getting Credstash secret failed!)
# endif

# # Set credstashoperator.instances.system.aws. overrides 
# SET_VALUES="--set credstashoperator.instances.system.aws.accessid=$(PROW_CREDSTASH_AWS_ACCESS_KEY_ID) \
# 						--set credstashoperator.instances.system.aws.secretaccesskey=$(PROW_CREDSTASH_AWS_SECRET_ACCESS_KEY)"

init:
	@mkdir -p .dist/
	@curl -Ls "$(PROW_INSTALLER_URL)" --output "$(CURDIR)/.dist/installer.tar.gz"
	@tar -xzf $(CURDIR)/.dist/installer.tar.gz -C .dist/
	@rm $(CURDIR)/.dist/installer.tar.gz

deploy: init 
	@$(MAKE) VALUES=../values.yaml SET_VALUES='$(SET_VALUES)' -C .dist DRY_RUN=false deploy

deploy-dry-run: init
	@$(MAKE) VALUES=../values.yaml SET_VALUES='$(SET_VALUES)' -C .dist DRY_RUN=true deploy