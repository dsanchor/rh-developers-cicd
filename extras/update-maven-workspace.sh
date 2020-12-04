#!/bin/bash
# Ex: ./update-maven-workspace.sh nexus3.nexus.svc.cluster.local:8081 cicd

NEXUS=$1
CICD_NS=$2

read -s -p "Enter admin Nexus password  : " PASSWORD

echo ""
echo "Updating settings.xml"
oc delete cm maven -n $CICD_NS
SETTINGS=`cat maven/settings.xml | NEXUS=$NEXUS NEXUS_ADMIN_PWD=$PASSWORD envsubst`
oc create cm maven --from-literal=settings.xml="${SETTINGS}" -n $CICD_NS
