#!/bin/bash

set -e

yaml_files=(
    ./k8s-resources/local-minikube-cluster/01-namespaces.yaml
    ./k8s-resources/local-minikube-cluster/02-configMap-postgres.yaml
    ./k8s-resources/local-minikube-cluster/03-persistenVolume-postgres.yaml
    ./k8s-resources/local-minikube-cluster/04-persistentVolumeClaim-postgres.yaml
    ./k8s-resources/local-minikube-cluster/05-deployment-postgres.yaml
    ./k8s-resources/local-minikube-cluster/06-service-postgres.yaml
    ./k8s-resources/local-minikube-cluster/07-configMap-backend.yaml
    ./k8s-resources/local-minikube-cluster/08-deploymentAndService-backend.yaml
    ./k8s-resources/local-minikube-cluster/09-deploymentAndService-frontend.yaml
)

for file in "${yaml_files[@]}"
do
    echo "Applying $file..."
    kubectl apply -f "$file"
done

echo "All YAML files have been applied successfully."
