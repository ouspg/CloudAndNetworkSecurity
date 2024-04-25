#!/bin/bash

if ! minikube status | grep -q "Running"; then
    echo "Minikube is not started properly, please start minikube via 'minikube start'"
fi


kubectl version > /dev/null 2>&1
if [ $? -eq 0 ];
    then
        echo "kubectl setup looks good."
    else
        echo "Please check kubectl setup."
        exit;
fi

helm version > /dev/null 2>&1
if [ $? -eq 0 ];
    then
        echo "Helm installation looks good."
    else
        echo $?
        exit;
fi

echo "Starting deployment of Kubernetes resources"

# helm install metadata-db deployments/metadata-db/ > /dev/null 2>&1 &
# helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace
# helm repo add jetstack https://charts.jetstack.io
# helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.7.1 --set installCRDs=true
# helm repo update

# Add new Kubernetes deployments here
kubectl apply -k deployments/wordpress/
kubectl apply -f deployments/

# Patch for Kind to make Ingress accessible from host
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

chmod +x deployments/wazuh/certs/indexer_cluster/generate_certs.sh
chmod +x deployments/wazuh/certs/dashboard_http/generate_certs.sh
. deployments/wazuh/certs/indexer_cluster/generate_certs.sh
cd -
. deployments/wazuh/certs/dashboard_http/generate_certs.sh
cd -

kubectl apply -f deployments/local-env/storage-class.yaml
kubectl apply -k deployments/local-env/

echo "All the Kubernetes resources have been deployed"
echo "Wait for the pods to be in running and in READY state before executing ./access.sh"
