#!/bin/bash

set -e

NS=$1

echo ""
echo "Installing buildah task from https://hub-preview.tekton.dev/"
oc apply -f \
 https://raw.githubusercontent.com/tektoncd/catalog/master/task/buildah/0.1/buildah.yaml \
 -n $NS
echo "Installing custom tasks"
oc apply -f tekton/custom-tasks/push-knative-manifest.yaml -n $NS
oc apply -f tekton/custom-tasks/workspace-cleaner.yaml -n $NS
echo "Installing knative-pipeline"
oc apply -f tekton/pipelines/knative-pipeline.yaml -n $NS 