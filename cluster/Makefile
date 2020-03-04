PROW_INSTALLER_URL = https://github.com/ouzi-dev/prow-installer/releases/download/v1.1.0/prow-installer-v1.1.0.tar.gz


PROW_CREDSTASH_AWS_ACCESS_KEY_ID=$(shell credstash get prow-credstash-reader-aws-access-key-id)
PROW_CREDSTASH_AWS_SECRET_ACCESS_KEY=$(shell credstash get prow-credstash-reader-aws-secret-access-key)

SET_VALUES="--set credstashoperator.instances.system.aws.accessid=$(PROW_CREDSTASH_AWS_ACCESS_KEY_ID) \
						--set credstashoperator.instances.system.aws.secretaccesskey=$(PROW_CREDSTASH_AWS_SECRET_ACCESS_KEY)"

init:
	@mkdir -p .dist/
	@curl –o .dist/installer.tar.gz $(PROW_INSTALLER_URL)
	@tar -xzf .dist/installer.tar.gz -C .dist/
	@rm .dist/installer.tar.gz

deploy:
	@$(MAKE) VALUES=../values.yaml SET_VALUES=$(SET_VALUES) -C .dist DRY_RUN=false deploy

deploy-dry-run:
	@$(MAKE) VALUES=../values.yaml SET_VALUES=$(SET_VALUES) -C .dist DRY_RUN=true deploy