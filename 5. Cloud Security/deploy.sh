#!/bin/bash
# This is a modified script of Madhu Akula's Kubernetes Goat

# Deploy to kind cluster (emulate Kubernetes with Docker)
# See https://kind.sigs.k8s.io/

CLUSTER_NAME="kind-cloudsec"

if ! command -v kind &> /dev/null; then
    echo "Kind is not installed. Please install Kind to use this script."
    exit 1
fi

if kind get clusters | grep -q "$CLUSTER_NAME"; 
    then
        echo "Kind cluster '$CLUSTER_NAME' exists."
    else
        echo "Kind cluster '$CLUSTER_NAME' does not exist, creating a new Kind cluster."
        kind create cluster --config deployments/kind-cluster-config/kind-cluster-setup.yaml --name kind-cloudsec
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

helm install metadata-db deployments/metadata-db/ > /dev/null 2>&1 &
helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace
helm repo add jetstack https://charts.jetstack.io
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.7.1 --set installCRDs=true
helm repo update

# Add new Kubernetes deployments here
kubectl apply -k deployments/wordpress/
kubectl apply -f deployments/
kubectl apply -f ingress.yaml

# Patch for Kind to make Ingress accessible from host
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# Create a WordPress site
kubectl wait --for=condition=ready --timeout=5m pod -l app=wpcli
kubectl wait --for=condition=ready --timeout=5m pod -l app=wordpress
WP_CLI_POD=$(kubectl get pod -l app=wpcli -o jsonpath="{.items[0].metadata.name}")
kubectl exec $WP_CLI_POD -- wp core install --url=https://blog.kyber.local --title="Our Blog To Make World More Secure" --admin_user=username --admin_password=password --admin_email=admin@test.com
# OpenID Connect plugin
kubectl exec $WP_CLI_POD -- wp plugin install miniorange-login-with-eve-online-google-facebook --activate

echo "All the Kubernetes resources have been deployed"
echo "Wait for the pods to be in running and in READY state before executing ./access.sh"