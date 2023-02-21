# stunning-journey-infra

## Useful commands
1. kc logs deployment/backend-deployment -n main-project
2. kc get events --all-namespaces  --sort-by='.metadata.creationTimestamp'
3. minikube service backend-service -n main-project