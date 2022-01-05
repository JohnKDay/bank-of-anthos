#!/usr/bin/env bash 

# Deploy the app, but check for a clsuter and the DF K8s webhook running.

# Check if kubectl is connecting to a K8s cluster and command exists.
kubectl cluster-info >/dev/null 2>&1
returnValue=$?
if [ ${returnValue} -ne 0 ]; then
   echo "Kubernetes cluster issue"
   exit 1
fi

# Check if DF webhook runtime is running in K8s cluster
svccnt=$(kubectl get pods --field-selector=status.phase=Running -n df-registration --no-headers 2>/dev/null | wc -l)
if [ ${svccnt} -ne 1 ]; then
   echo "DeepFactor webhook not deployed or running in kubnernetes cluster"
   exit 1
    
fi

# If $1 is set to deploy to namespace

NAMESPACE=${1:-default}


# Create namespace if it doesn't exist
kubectl create ns ${NAMESPACE} 2>/dev/null

# Deploy the jwt
kubectl apply -n ${NAMESPACE} -f ../extras/jwt

# Deploy the application 
kubectl apply -n ${NAMESPACE} -f ../kubernetes-manifests

# Watch the application start
echo 
echo
echo "use kubectl to watch application start"
echo "kubectl get pods -n ${NAMESPACE}"
