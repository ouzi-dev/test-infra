.PHONY: fmt infra-plan infra-apply infra-destroy infra-output install uninstall deploy get-cluster-credentials

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

install: infra-apply get-cluster-credentials
	@$(MAKE) -C prow install

uninstall: get-cluster-credentials
	@$(MAKE) -C prow uninstall
	@$(MAKE) infra-destroy

get-cluster-credentials:
	@$(MAKE) -C infrastructure get-cluster-credentials