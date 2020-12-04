#!/bin/bash
# Ex: ./deploy-nexus.sh nexus alpha

NEXUS_NS=$1
NEXUS_CHANNEL=$2

echo "Creating project for nexus called $NEXUS_NS"
oc new-project $NEXUS_NS

echo "Creating Operator group for $NEXUS_NS"
oc apply -f - -n $NEXUS_NS<<EOF
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: nexus-og
spec:
  targetNamespaces:
  - ${NEXUS_NS}
EOF

echo "Installing Nexus operator"
oc apply -f - -n $NEXUS_NS<<EOF
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: nexus-operator-m88i
spec:
  channel: ${NEXUS_CHANNEL}
  name: nexus-operator-m88i
  source: community-operators
  sourceNamespace: openshift-marketplace
EOF

while [ `oc get pods -n $NEXUS_NS | grep nexus-operator | grep "2/2" | wc -l` -eq 0 ]
do
  echo "Waiting for Nexus operator to be installed"
  sleep 10
done
echo "Nexus operator installed succesfully"

echo "Installing Nexus"
oc apply -f - -n $NEXUS_NS<<EOF
apiVersion: apps.m88i.io/v1alpha1
kind: Nexus
metadata:
  name: nexus3
spec:
  resources:
    limits:
      cpu: '2'
      memory: 2Gi
    requests:
      cpu: '500m'
      memory: 256Mi
  useRedHatImage: true
  generateRandomAdminPassword: false
  networking:
    expose: true
    exposeAs: Route
  replicas: 1
  persistence:
    persistent: true
    volumeSize: 10Gi
EOF

echo ""
while [ `oc get pods -n $NEXUS_NS | grep nexus3 | grep "1/1" | wc -l` -eq 0 ]
do
  echo "Waiting for Nexus to start"
  sleep 10
done
echo "Nexus is now running"