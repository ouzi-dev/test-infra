DIR = $(shell pwd)

.PHONY: fmt
fmt:
	@$(MAKE) -C infrastructure fmt

.PHONY: infra-setup
infra-setup:
	@$(MAKE) -C infrastructure setup

.PHONY: infra-plan
infra-plan:
	@$(MAKE) -C infrastructure plan

.PHONY: infra-apply
infra-apply:
	@$(MAKE) -C infrastructure TF_ARGS=-auto-approve apply

.PHONY: infra-destroy
infra-destroy:
	@$(MAKE) -C infrastructure destroy	

.PHONY: infra-output
infra-output:
	@$(MAKE) -C infrastructure output	

.PHONY: deploy
deploy:
	@$(MAKE) -C cluster setup deploy

.PHONY: deploy-prow-config
deploy-prow-config: 
	@$(MAKE) -C prow deploy-prow-config

.PHONY: deploy-dry-run
deploy-dry-run: 
	@$(MAKE) -C cluster DRY_RUN=true setup deploy

.PHONY: get-cluster-credentials
get-cluster-credentials:
	@$(MAKE) -C infrastructure get-cluster-credentials

.PHONY: monitoring-dry-run
monitoring-dry-run:
	@$(MAKE) -C monitoring monitoring-dry-run

.PHONY: monitoring-apply
monitoring-apply:
	@$(MAKE) -C monitoring monitoring-apply

.PHONY: dev-test-config
dev-test-config:
	@docker run -v $(DIR)/:/test-infra  gcr.io/k8s-prow/checkconfig:v20191028-a687a71be --config-path=/test-infra/prow/config.yaml --plugin-config=/test-infra/prow/plugins.yaml  --job-config-path=/test-infra/config/jobs