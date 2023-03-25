#!/bin/bash

set -e

yaml_files=(
    01-namespaces.yaml
    02-configMap-postgres.yaml
    03-persistenVolume-postgres.yaml
    04-persistentVolumeClaim-postgres.yaml
    05-deployment-postgres.yaml
    06-service-postgres.yaml
    07-configMap-backend.yaml
    08-deploymentAndService-backend.yaml
)

for file in "${yaml_files[@]}"
do
    echo "Applying $file..."
    kubectl apply -f "$file"
done

echo "All YAML files have been applied successfully."
