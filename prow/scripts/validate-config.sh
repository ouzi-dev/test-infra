#!/usr/bin/env bash

K8S_TEST_INFRA_PATH="${K8S_TEST_INFRA_PATH:-${HOME}/go/src/k8s.io/test-infra/hack}"
BELITRADAS_TEST_INFRA_PATH="${BELITRADAS_TEST_INFRA_PATH:-$HOME/go/src/github.com/belitradas/test-infra}"

cd $K8S_TEST_INFRA_PATH

bazel run //prow/cmd/checkconfig -- --plugin-config=$BELITRADAS_TEST_INFRA_PATH/prow/plugins.yaml --config-path=$BELITRADAS_TEST_INFRA_PATH/prow/config.yaml --job-config-path=$BELITRADAS_TEST_INFRA_PATH/config/jobs
