#!/bin/bash

set -e

yaml_files=(
    09-deploymentAndService-frontend.yaml
    08-deploymentAndService-backend.yaml
    07-configMap-backend.yaml
    06-service-postgres.yaml
    05-deployment-postgres.yaml
    04-persistentVolumeClaim-postgres.yaml
    03-persistenVolume-postgres.yaml
    02-configMap-postgres.yaml
    01-namespaces.yaml
)

for file in "${yaml_files[@]}"
do
    echo "Deleting resources from $file..."
    kubectl delete -f "$file"
done

echo "All resources have been deleted successfully."
