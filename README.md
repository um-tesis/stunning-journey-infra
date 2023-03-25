# stunning-journey-infra

### Useful commands
1. kc logs deployment/backend-deployment -n main-project
2. kc get events --all-namespaces  --sort-by='.metadata.creationTimestamp'
4. minikube image pull jfer11/thesis-backend:vX-release
5. kc get pod -o wide -n main-project
6. minikube service backend-service -n main-project --url
7. kubectl logs --selector app=nestjs -n main-project

como verga actualizar correctamente las envs en postman?

### How to build and push an image to dockerhub
`WORKING DIR .`
1. docker login
2. docker build -t <your-docker-hub-id>/<image-name>:<new-version> .
3. docker tag <your-docker-hub-id>/<image-name>:<new-version> <your-docker-hub-id>/<image-name>:<new-version>-release
4. docker push <your-docker-hub-id>/<image-name>:<new-version>-release

**For example:**
**DO NOT COPY-PASTE - there is a v1 tag:**
- docker build -t jfer11/thesis-backend:v1 .
- docker tag jfer11/thesis-backend:v1 jfer11/thesis-backend:v1-release
- docker push jfer11/thesis-backend:v1-release
