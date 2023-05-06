#!/bin/bash

set -e

yaml_files=(
    ./k8s-resources/aws-eks-production-cluster/09-deploymentAndService-frontend.yaml
    ./k8s-resources/aws-eks-production-cluster/08-deploymentAndService-backend.yaml
    ./k8s-resources/aws-eks-production-cluster/07-configMap-backend.yaml
    ./k8s-resources/aws-eks-production-cluster/06-service-postgres.yaml
    ./k8s-resources/aws-eks-production-cluster/05-deployment-postgres.yaml
    ./k8s-resources/aws-eks-production-cluster/04-persistentVolumeClaim-postgres.yaml
    ./k8s-resources/aws-eks-production-cluster/03-persistenVolume-postgres.yaml
    ./k8s-resources/aws-eks-production-cluster/02-configMap-postgres.yaml
    ./k8s-resources/aws-eks-production-cluster/01-namespaces.yaml
)

for file in "${yaml_files[@]}"
do
    echo "Deleting resources from $file..."
    kubectl delete -f "$file"
done

echo "All resources have been deleted successfully."
