# installer url
# PROW_INSTALLER_URL = file://$(CURDIR)/../../prow-installer/.dist//prow-installer-canary.tar.gz
PROW_INSTALLER_URL = https://github.com/ouzi-dev/prow-installer/releases/download/v1.15.1/prow-installer-v1.15.1.tar.gz

# make sure make fails on shell errors 
# caveat: does not work for the shell function
SHELL = /usr/bin/env bash -eo pipefail

# Set credstashoperator.instances.system.aws. overrides 
SET_VALUES="--set credstashoperator.instances.system.aws.accessid=$(shell credstash --region eu-west-1 get prow-credstash-reader-aws-access-key-id) \
						--set credstashoperator.instances.system.aws.secretaccesskey=$(shell credstash --region eu-west-1 get prow-credstash-reader-aws-secret-access-key)"

init:
	@mkdir -p .dist/
	@curl -Ls "$(PROW_INSTALLER_URL)" --output "$(CURDIR)/.dist/installer.tar.gz"
	@tar -xzf $(CURDIR)/.dist/installer.tar.gz -C .dist/
	@rm $(CURDIR)/.dist/installer.tar.gz

deploy: init 
	@$(MAKE) VALUES=../values.yaml SET_VALUES='$(SET_VALUES)' -C .dist DRY_RUN=false init deploy

deploy-dry-run: init
	@$(MAKE) VALUES=../values.yaml SET_VALUES='$(SET_VALUES)' -C .dist DRY_RUN=true init deploy

clean:
	@rm -r .dist/