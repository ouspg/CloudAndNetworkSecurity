#!/bin/bash

set -e
set -o errexit
set -o nounset
set -o pipefail

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

helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace
helm repo add jetstack https://charts.jetstack.io
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.7.1 --set installCRDs=true
helm repo update

git clone --branch v4.11.2 --depth 1 https://github.com/wazuh/wazuh-kubernetes.git wazuh

chmod +x wazuh/wazuh/certs/indexer_cluster/generate_certs.sh
chmod +x wazuh/wazuh/certs/dashboard_http/generate_certs.sh

bash wazuh/wazuh/certs/indexer_cluster/generate_certs.sh
bash wazuh/wazuh/certs/dashboard_http/generate_certs.sh

echo "All Kubernetes dependencies have been installed and self-signed certificates have been generated."
