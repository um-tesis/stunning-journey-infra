#!/bin/bash

set -e

yaml_files=(
    ./kubernetes/01-namespaces.yaml
    ./kubernetes/02-configMap-postgres.yaml
    ./kubernetes/03-persistenVolume-postgres.yaml
    ./kubernetes/04-persistentVolumeClaim-postgres.yaml
    ./kubernetes/05-deployment-postgres.yaml
    ./kubernetes/06-service-postgres.yaml
    ./kubernetes/07-configMap-backend.yaml
    ./kubernetes/08-deploymentAndService-backend.yaml
    ./kubernetes/09-deploymentAndService-frontend.yaml
)

for file in "${yaml_files[@]}"
do
    echo "Applying $file..."
    kubectl apply -f "$file"
done

echo "All YAML files have been applied successfully."
