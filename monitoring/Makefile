IS_JB := $(shell command -v jb;)
IS_GOJSONTOYAML := $(shell command -v gojsontoyaml;)
IS_JSONNET := $(shell command -v jsonnet;)

KUBE_PROM_FOLDER := ./kube-prometheus
KUBE_PROM_JSONNET_FILE := $(KUBE_PROM_FOLDER)/kube-prometheus.jsonnet

MANIFESTS_FOLDER := manifests
PROM_FOLDER := $(MANIFESTS_FOLDER)/prometheus
EXPOSE_FOLDER := $(MANIFESTS_FOLDER)/expose

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

init: bootstrap
	jb init

install: bootstrap
	jb install 

update: bootstrap
	jb update

compile: bootstrap 
	rm -rf $(PROM_FOLDER)
	mkdir $(PROM_FOLDER)
	jsonnet -J vendor -m $(PROM_FOLDER) "$(KUBE_PROM_JSONNET_FILE)" | xargs -I{} sh -c 'cat {} | gojsontoyaml > {}.yaml; rm -f {}' -- {}

monitoring-dry-run: compile
	kubectl apply -f$(PROM_FOLDER) --dry-run
	kubectl apply -f $(EXPOSE_FOLDER) --dry-run

monitoring: compile
	kubectl apply -f $(PROM_FOLDER)
	kubectl apply -f $(EXPOSE_FOLDER)
