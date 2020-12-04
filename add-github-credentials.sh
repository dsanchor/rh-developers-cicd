#!/bin/bash

set -e

NS=$1
USERNAME=$2
PASSWORD=$3

echo " "

echo "Creating secret with github credentials for user $USERNAME"
cat tekton/k8s-resources/git-secret.yaml | USERNAME=$USERNAME \
  PASSWORD=$PASSWORD envsubst | oc apply -f - -n $NS 

echo "Linking pipeline sa in namespace $NS with your github crendentials"
oc patch serviceaccount pipeline -p \
  '{"secrets": [{"name": "github-credentials"}]}' \
  -n $NS 