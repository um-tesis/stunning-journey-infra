#!/bin/bash

set -e

yaml_files=(
    ./kubernetes/09-deploymentAndService-frontend.yaml
    ./kubernetes/08-deploymentAndService-backend.yaml
    ./kubernetes/07-configMap-backend.yaml
    ./kubernetes/06-service-postgres.yaml
    ./kubernetes/05-deployment-postgres.yaml
    ./kubernetes/04-persistentVolumeClaim-postgres.yaml
    ./kubernetes/03-persistenVolume-postgres.yaml
    ./kubernetes/02-configMap-postgres.yaml
    ./kubernetes/01-namespaces.yaml
)

for file in "${yaml_files[@]}"
do
    echo "Deleting resources from $file..."
    kubectl delete -f "$file"
done

echo "All resources have been deleted successfully."
