#!/bin/bash

set -e

NS=$1
#STORAGE_CLASS=$2

echo ""

echo "Creating knative-kustomize-base ConfigMap with base kustomize files \
  for Knative services"
oc create cm knative-kustomize-base \
  --from-file=tekton/workspaces/knative/base/kservice.yaml \
  --from-file=tekton/workspaces/knative/base/kustomization.yaml \
  --from-file=tekton/workspaces/knative/base/global-ops-configmap.yaml \
  -n $NS

echo "Creating knative-kustomize-environment ConfigMap with environment \
  dependant kustomize files"
oc create cm knative-kustomize-environment \
  --from-file=tekton/workspaces/knative/environment/traffic-routing.yaml \
  --from-file=tekton/workspaces/knative/environment/kustomization.yaml \
  --from-file=tekton/workspaces/knative/environment/revision-patch.yaml \
  --from-file=tekton/workspaces/knative/environment/routing-patch.yaml \
  --from-file=tekton/workspaces/knative/environment/env-ops-configmap.yaml \
  -n $NS 

echo "Creating maven ConfigMap with settings.xml"
oc create cm maven --from-file=tekton/workspaces/maven/settings.xml \
 -n $NS  

echo "Creating PVC using default storage class"
oc apply -f tekton/workspaces/source-pvc/pvc.yaml -n $NS 

# echo "Creating PVC with storage class => $STORAGE_CLASS"
# cat tekton/workspaces/source-pvc/pvc.yaml  | STORAGE_CLASS=$STORAGE_CLASS envsubst \
#   | kubectl apply -f - -n $NS 
