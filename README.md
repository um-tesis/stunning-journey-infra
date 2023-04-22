# Libera Infra

## Useful Commands
Here are some useful commands for working with Kubernetes and Docker.

#### Viewing Logs
- To view logs from a deployment:

  `kc logs deployment/backend-deployment -n main-project`

- To view logs from a deployment filtered by app name:

  `kubectl logs --selector app=nestjs -n main-project`

#### Viewing Kubernetes Events

- To view interesting Kubernetes events, run:

  `kc get events --all-namespaces --sort-by='.metadata.creationTimestamp'`

#### Troubleshooting

- If an image is too large to load in minikube when running `kc apply -f ./kubernetes/<filename>`, try running:

  `minikube image pull jfer11/thesis-backend:vX-release`

  **Replace X with the release version.**

- To view the ports and IPs of pods:

  `kc get pod -o wide -n main-project`

- To expose a LoadBalancer service port to the outside, run:

  `minikube service backend-service -n main-project --url`

## Building and Pushing Images to Dockerhub

Here are the steps to build and push an image to Dockerhub:

1. Log in to Dockerhub using `docker login`.
2. Build the image using `docker build -t <your-docker-hub-id>/<image-name>:<new-version> .`
3. Tag the image using `docker tag <your-docker-hub-id>/<image-name>:<new-version> <your-docker-hub-id>/<image-name>:<new-version>-release`
4. Push the image using `docker push <your-docker-hub-id>/<image-name>:<new-version>-release`

For example:

```
docker build -t jfer11/thesis-backend:v1 .
docker tag jfer11/thesis-backend:v1 jfer11/thesis-backend:v1-release
docker push jfer11/thesis-backend:v1-release
```

Note: **Do NOT copy-paste** the example above, as it includes the v1 tag which may not be appropriate for your use case