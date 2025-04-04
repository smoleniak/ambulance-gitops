#!/bin/bash
# Script for force-deleting a namespaces stuck in "terminating" phase
# Check if a namespace name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <namespace-name>"
  exit 1
fi

NAMESPACE=$1

echo "Attempting to remove finalizers from namespace: $NAMESPACE"

# Run the finalizer removal command
kubectl get namespace "$NAMESPACE" -o json | jq '.spec.finalizers=[]' | kubectl replace --raw "/api/v1/namespaces/$NAMESPACE/finalize" -f -

# Check if the namespace still exists
if kubectl get namespace "$NAMESPACE" &>/dev/null; then
  echo "Namespace $NAMESPACE still exists. It may be stuck in Terminating state."
else
  echo "Namespace $NAMESPACE successfully deleted."
fi
