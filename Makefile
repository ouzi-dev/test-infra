.PHONY: fmt infra-plan infra-apply infra-destroy infra-output deploy deploy-prow deploy-prow-dry-run get-cluster-credentials

fmt:
	@$(MAKE) -C infrastructure fmt

infra-setup:
	@$(MAKE) -C infrastructure setup

infra-plan:
	@$(MAKE) -C infrastructure plan

infra-apply:
	@$(MAKE) -C infrastructure apply

infra-destroy:
	@$(MAKE) -C infrastructure destroy	

infra-output:
	@$(MAKE) -C infrastructure output	

deploy:
	@$(MAKE) -C cluster deploy

.PHONY: deploy-prow-config
deploy-prow-config: 
	@$(MAKE) -C prow deploy-prow-config

.PHONY: deploy-dry-run
deploy-dry-run: 
	@$(MAKE) -C cluster DRY_RUN=true deploy

get-cluster-credentials:
	@$(MAKE) -C infrastructure get-cluster-credentials

monitoring-dry-run:
	@$(MAKE) -C monitoring monitoring-dry-run

monitoring-apply:
	@$(MAKE) -C monitoring monitoring-apply