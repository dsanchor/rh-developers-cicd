#!/bin/bash

set -e

echo ""

echo "Creating knative-serving namespace"
kubectl apply -f knative/knative-serving.yaml

echo "Installing basic knative serving control plane"
kubectl apply -f knative/knative-serving-instance.yaml --namespace=knative-serving