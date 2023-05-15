# Libera Infra

------

# Terraform 

TODO: Missing explanation here about what is going to be created. Add some diagrams.
Also, check [here](https://www.notion.so/Infra-Notas-Fer-1b6588f3575043c597191055dce7a35c) to determine what should be pasted here as well.

## Prequisites

Link [here](https://www.notion.so/Infra-Notas-Fer-1b6588f3575043c597191055dce7a35c?pvs=4#f9fbc71eed494106906b1bc4fe567584).
TODO: Move the information here.

## Main commands you should know before running terraform

- `terraform init`. This will initializes a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. This command is always safe to run multiple times, to bring the working directory up to date with changes in the configuration. Though subsequent runs may give errors, this command will never delete your existing configuration or state. It will initialize modules, provider plugins amog other important stuff.
Also, it creates a lock file *.terraform.lock.hcl* to record the provider selections made above. Include this file in your version control repository so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

- `terraform plan`. The terraform plan command creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure. By default, when Terraform creates a plan it:
   1. Reads the current state of any already-existing remote objects to make sure that the Terraform state is up-to-date.
   2. Compares the current configuration to the prior state and noting any differences.
   3. Proposes a set of change actions that should, if applied, make the remote objects match the configuration.
The **plan** command alone does not actually carry out the proposed changes You can use this command to check whether the proposed changes match what you expected before you apply the changes or share your changes with your team for broader review.
So after all, if the planned changes are OK, proceed with the apply command.

- `terraform apply`. The terraform apply command executes the actions proposed in a Terraform plan.

- `terraform destroy`. The terraform destroy command is a convenient way to destroy all remote objects managed by a particular Terraform configuration. You can also create a speculative destroy plan, to see what the effect of destroying would be, by running the following command: `terraform plan -destroy`.

## How to Create Libera Infrastructure in AWS from Scratch

Working directory: **terraform**.

1. Execute `terraform init` to initialize modules, provider plugins and other necessary resources.
2. Execute `terraform plan`. to see the plan of 70 resources that will be created: *Plan: 70 to add, 0 to change, 0 to destroy*. FYI, the file should look similar to the one [here](https://www.notion.so/Infra-Notas-Fer-1b6588f3575043c597191055dce7a35c?pvs=4#2150437e95e34523843db31588ca5233).
3. Execute `terraform apply` to apply the plan. This may **take a few minutes**, so do not worry about it.

Once the creation is complete, you'll need to connect your Kubernetes command-line tool (kubectl) to the newly created cluster.

1. Run: `aws eks update-kubeconfig --name libera-eks --region us-east-1 --profile fer-libera`. To test the connection, run `kubectl get nodes` and verify that at least two nodes are listed.

At this point, your Kubernetes cluster has been created BUT is still empty. To validate that the cluster was created correctly, you can schedule an echoserver inside the cluster and try to request it from outside.

Working directory: **root directory**.

5. Execute `kubectl apply -f echoserver.yaml`. to schedule the echoserver. After a few minutes, it should be created.
6. Run: `kubectl get ingress`. This will give you information such as NAME, CLASS, HOSTS ADDRESS, PORTS and AGE. You need to copy the ADDRESS. *Ex: k8s-default-echoserv-798f5770a5-767024838.us-east-1.elb.amazonaws.com*
7. Paste the ADDRESS into your browser, and if you receive a proper response, your cluster is working correctly.

At this point, you have validated that the cluster is working as expected. Now, you need to remove the echoserver and add the actual Kubernetes deployments and other resources.

Working directory: **root directory**.

8. To remove the echoserver execute: `kubectl delete -f echoserver.yaml`.

9. To add each Libera Kubernetes component run: `<TO BE CREATED>`.

-----

# Minikube

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
