IS_JB := $(shell command -v jb;)
IS_GOJSONTOYAML := $(shell command -v gojsontoyaml;)
IS_JSONNET := $(shell command -v jsonnet;)

KUBE_PROM_FOLDER := ./kube-prometheus
KUBE_PROM_JSONNET_FILE := $(KUBE_PROM_FOLDER)/kube-prometheus.jsonnet

MANIFESTS_FOLDER := manifests
PROM_FOLDER := $(MANIFESTS_FOLDER)/prometheus
EXPOSE_FOLDER := $(MANIFESTS_FOLDER)/expose
SERVICE_MONITORS_FOLDER := $(MANIFESTS_FOLDER)/service-monitors

GRAFANA_DASHBOARDS_JSONNET_FILE := ./grafana-dashboards/dashboards.jsonnet
GRAFANA_DASHBOARDS_RAW_JSON_FOLDER := ./grafana-dashboards/raw
GRAFANA_DASHBOARDS_FOLDER := ./grafana-dashboards/output

.PHONY: bootstrap
bootstrap:
ifndef IS_JB
	go get -u github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb
endif
ifndef IS_GOJSONTOYAML
	go get -u github.com/brancz/gojsontoyaml
endif
ifndef IS_JSONNET
	go get github.com/google/go-jsonnet/cmd/jsonnet
endif

.PHONY: init
init: bootstrap
	jb init

.PHONY: install
install: bootstrap
	jb install 

.PHONY: update
update: bootstrap
	jb update

.PHONY: compile
compile: 
	rm -rf $(PROM_FOLDER)
	mkdir $(PROM_FOLDER)
	MANIFESTS_PATH=${PROM_FOLDER} ./build.sh $(KUBE_PROM_JSONNET_FILE)

.PHONY: prometheus-dry-run
prometheus-dry-run: bootstrap install compile
	kubectl apply -f $(PROM_FOLDER) --dry-run
	kubectl apply -f $(EXPOSE_FOLDER) --dry-run

.PHONY: prometheus
prometheus: bootstrap install compile
	kubectl apply -f $(PROM_FOLDER)
	kubectl apply -f $(EXPOSE_FOLDER)

.PHONY: grafana-dashboards
grafana-dashboards:
	rm -rf $(GRAFANA_DASHBOARDS_FOLDER)
	mkdir $(GRAFANA_DASHBOARDS_FOLDER)
	jsonnet -J vendor -m ${GRAFANA_DASHBOARDS_FOLDER} "$(GRAFANA_DASHBOARDS_JSONNET_FILE)"

.PHONY: grafana
grafana: grafana-dashboards helm-bootstrap
	helm upgrade --install grafana stable/grafana \
		--tiller-namespace kube-system \
		--namespace monitoring \
		--atomic \
		-f grafana/values.yaml \
		-f grafana-dashboards/output/values.json \
		--version 4.0.0	--timeout 120

.PHONY: grafana-dry-run
grafana-dry-run: grafana-dashboards helm-bootstrap
	helm upgrade --install grafana stable/grafana \
		--tiller-namespace kube-system \
		--namespace monitoring \
		--atomic \
		-f grafana/values.yaml \
		-f grafana-dashboards/output/values.json \
		--version 4.0.0 --timeout 120 \
		--debug --dry-run

.PHONY: service-monitors-dry-run
service-monitors-dry-run:
	kubectl apply -f $(SERVICE_MONITORS_FOLDER) --dry-run

.PHONY: service-monitors
service-monitors:
	kubectl apply -f $(SERVICE_MONITORS_FOLDER)

.PHONY: monitoring-dry-run
monitoring-dry-run: prometheus-dry-run grafana-dry-run service-monitors-dry-run

.PHONY: monitoring-apply
monitoring-apply: prometheus grafana service-monitors

.PHONY: helm-bootstrap
helm-bootstrap:
	helm init --client-only
	helm repo update

.PHONY: grafana-secret
.ONESHELL:
grafana-secret:
	@$(eval USERNAME := $(shell credstash get prow-grafana-admin-user))
	@$(eval PASSWORD := $(shell credstash get prow-grafana-admin-password))
	@kubectl create secret generic grafana-user \
		--from-literal=admin-user=$(USERNAME) \
		--from-literal=admin-password=$(PASSWORD) \
		-n monitoring --dry-run -o yaml | kubectl apply -f -