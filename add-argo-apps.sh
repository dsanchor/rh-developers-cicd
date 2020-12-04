#!/bin/bash

set -e

NS=$1
TEAM=$2
GITOPS_REPO=$3
GITOPS_REPO_REV=$4

echo ""

echo "Installing basic ArgoCD server instance"
oc apply -f argocd-apps/argocd.yaml -n $NS


echo "Adding edit role to argocd-application-controller ServiceAccount in projects development, staging and production"
cat argocd-apps/argo-role-bindings.yaml  | CICD_NS=$NS TEAM=$TEAM envsubst \
  | oc apply -f - 

echo "Creating ${TEAM} AppProject in namespace ${NS}"
cat argocd-apps/argo-app-project.yaml  | CICD_NS=$NS TEAM=$TEAM envsubst \
  | oc apply -f - -n $NS 

echo "Creating Applications in namespace ${NS} in ${TEAM} AppProject"
cat argocd-apps/argo-apps.yaml  | CICD_NS=$NS TEAM=$TEAM \
  DEPLOYMENT_REPOSITORY_URL=$GITOPS_REPO \
  DEPLOYMENT_REPOSITORY_REVISION=$GITOPS_REPO_REV envsubst \
  | oc apply -f - -n $NS 