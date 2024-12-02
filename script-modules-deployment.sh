#!/bin/bash

DEPLOYMENT_NAME="intranet"
NAMESPACE="default" 

POD_NAME=$(kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT_NAME -o=jsonpath='{.items[0].metadata.name}')

if [ -z "$POD_NAME" ]; then
  echo "Pod not found for deployment $DEPLOYMENT_NAME in namespace $NAMESPACE!"
  exit 1
fi

echo "Found pod: $POD_NAME"

echo "Copying modules into pod $POD_NAME..."
kubectl cp ./modules/. $POD_NAME:/mnt/extra-addons/

echo "Restarting deployment $DEPLOYMENT_NAME..."
kubectl rollout restart deployment $DEPLOYMENT_NAME -n $NAMESPACE

echo "Checking the status of the pods..."
kubectl get pods -n $NAMESPACE

echo "Checking PVC..."
kubectl get pvc -n $NAMESPACE
