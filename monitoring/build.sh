#!/usr/bin/env bash

# This script uses arg $1 (name of *.jsonnet file to use) to generate the manifests/*.yaml files.

set -euo pipefail

# Make sure to start with a clean 'manifests' dir
rm -rf ${MANIFESTS_PATH}
mkdir -p ${MANIFESTS_PATH}

jsonnet -J vendor -m ${MANIFESTS_PATH} "${1-example.jsonnet}"

for filename in ${MANIFESTS_PATH}/*; do
    cat ${filename} | gojsontoyaml > ${filename}.yaml
    rm -f ${filename}
done
