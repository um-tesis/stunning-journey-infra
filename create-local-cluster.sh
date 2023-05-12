#!/bin/bash

set -e

yaml_files=(
    ./k8s-resources/local-minikube-cluster/01-namespaces.yaml
    ./k8s-resources/local-minikube-cluster/02-deploymentAndService-postgres.yaml
    ./k8s-resources/local-minikube-cluster/03-configMap-backend.yaml
    ./k8s-resources/local-minikube-cluster/04-deploymentAndService-backend.yaml
    ./k8s-resources/local-minikube-cluster/05-deploymentAndService-frontend.yaml
)

for file in "${yaml_files[@]}"
do
    echo "Applying $file..."
    kubectl apply -f "$file"
done

echo "All YAML files have been applied successfully."
