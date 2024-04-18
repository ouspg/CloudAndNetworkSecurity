#!/bin/bash
# This is a modified script of Madhu Akula's Kubernetes Goat

kubectl version > /dev/null 2>&1 
if [ $? -eq 0 ];
then
    echo "kubectl setup looks good."
else 
    echo "Error: Could not find kubectl or an other error happened, please check kubectl setup."
    exit;
fi

kubectl port-forward service/wordpress 8080:80 > /dev/null 2>&1 &

export POD_NAME=$(kubectl get pods --namespace default -l "app=flask-webservice" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME --address 0.0.0.0 1230:3000 > /dev/null 2>&1 &

export POD_NAME=$(kubectl get pods --namespace default -l "app=health-check" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME --address 0.0.0.0 1231:80 > /dev/null 2>&1 &

export POD_NAME=$(kubectl get pods --namespace default -l "app=postgresql" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME --address 0.0.0.0 5432:5432 > /dev/null 2>&1 &

export POD_NAME=$(kubectl get pods --namespace default -l "app=internal-proxy" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME --address 0.0.0.0 1232:3000 > /dev/null 2>&1 &

export POD_NAME=$(kubectl get pods --namespace default -l "app=system-monitor" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME --address 0.0.0.0 1233:8080 > /dev/null 2>&1 &

export POD_NAME=$(kubectl get pods --namespace default -l "app=keycloak" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME --address 0.0.0.0 6006:8080 > /dev/null 2>&1 &

export POD_NAME=$(kubectl get pods --namespace default -l "app=wordpress" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME --address 0.0.0.0 80:80 > /dev/null 2>&1 &

echo "Laboratory environment ready."
