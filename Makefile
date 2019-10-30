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

deploy: infra-apply 
	@$(MAKE) -C prow deploy

deploy-prow: 
	@$(MAKE) -C prow deploy-prow

deploy-prow-dry-run: 
	@$(MAKE) -C prow deploy-prow-dry-run	

get-cluster-credentials:
	@$(MAKE) -C infrastructure get-cluster-credentials

monitoring-dry-run:
	@$(MAKE) -C monitoring monitoring-dry-run

monitoring:
	@$(MAKE) -C monitoring monitoring