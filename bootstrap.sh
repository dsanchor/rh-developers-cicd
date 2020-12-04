#!/bin/bash

set -e

# helm dependency build bootstrap
# helm upgrade --install bootstrap bootstrap
echo ""
# install helms charts that will initialize the environment 
echo "Installing openshift-pipelines operator"
helm upgrade --install openshift-pipelines openshift-pipelines
echo ""
echo "Installing openshift-serverless" 
helm upgrade --install openshift-serverless openshift-serverless
echo ""
echo "Creating cicd, development, staging and production namespaces"
echo "Added cicd system:image-puller role to default sa in development, staging and production namespaces"
echo "Added view role to default sa in development, staging and production namespaces"
helm upgrade --install bootstrap-projects bootstrap-projects

