#!/bin/bash

set -e

NS=$1

echo ""
# install helms charts that will initialize argocd related stuff
echo "Installing argo operator"
helm upgrade --install argocd argocd --set namespace=$NS