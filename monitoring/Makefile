IS_JB := $(shell command -v jb;)
IS_GOJSONTOYAML := $(shell command -v gojsontoyaml;)
IS_JSONNET := $(shell command -v jsonnet;)

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
	rm -rf manifests
	mkdir manifests
	jsonnet -J vendor -m manifests "./kube-prometheus/kube-prometheus.jsonnet" | xargs -I{} sh -c 'cat {} | gojsontoyaml > {}.yaml; rm -f {}' -- {}
#	./build.sh ./kube-prometheus/ingress.jsonnet