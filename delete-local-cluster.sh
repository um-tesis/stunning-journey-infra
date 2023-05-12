#!/bin/bash

set -e

yaml_files=(
    ./k8s-resources/local-minikube-cluster/05-deploymentAndService-frontend.yaml
    ./k8s-resources/local-minikube-cluster/04-deploymentAndService-backend.yaml
    ./k8s-resources/local-minikube-cluster/03-configMap-backend.yaml
    ./k8s-resources/local-minikube-cluster/02-deploymentAndService-postgres.yaml
    ./k8s-resources/local-minikube-cluster/01-namespaces.yaml
)

for file in "${yaml_files[@]}"
do
    echo "Deleting resources from $file..."
    kubectl delete -f "$file"
done

echo "All resources have been deleted successfully."
