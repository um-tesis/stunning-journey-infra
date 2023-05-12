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


## Useful terraform commands

- `terraform output db_instance_password`: It prints the database password (this password may be old, because Terraform doesn't track it after initial creation).

-----

# Possible changes to the proposed infrastructure

## Public Access to RDS Instances

Note: Enabling public access to RDS instances is not recommended for production environments. Proceed with caution.

To allow public access to RDS instances, you need to make the following modifications to your project:

### **In `1-vpc.tf`:**

Add the following lines:

```
create_database_subnet_route_table = true
create_database_internet_gateway_route = true
```

The following parameters are also required, but they should already be defined:

```hclCopy code
create_database_subnet_group = true
enable_dns_hostnames = true
enable_dns_support = true
```

### **In `7-rds.tf`:**

Inside the **`ingress_with_cidr_blocks`** block, include the following:

```hclCopy code
ingress_with_cidr_blocks = [
  // Existing entries
  {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    description = "PostgreSQL access from outside the VPC"
    cidr_blocks = "0.0.0.0/0"
  },
]
```

These changes will enable public access to your RDS instances, allowing incoming connections on port 5432 from any IP address (**`0.0.0.0/0`**) within the VPC.

Remember, public access to RDS instances should only be used for specific scenarios and not for production environments due to security considerations.

-----

# Minikube

Minikube is a tool that allows you to run Kubernetes locally. It provides a single-node Kubernetes cluster on your local machine, making it easier to develop and test applications without the need for a full-scale production cluster.

## Prequisites

Before using Minikube, ensure that you have the following prerequisites installed:

1. Docker. Install Docker by following the instructions provided in the official Docker documentation [here](https://docs.docker.com/get-docker/).
2. Kubectl. Go to [Kubernetes page > Install Tools](https://kubernetes.io/docs/tasks/tools/), and install **kubectl**. The **Kubernetes command-line tool (kubectl)** allows you to run commands against Kubernetes clusters (in our case, Minikube).
3. Minikube. Download and install Minikube by visiting the official Minikube documentation [here](https://minikube.sigs.k8s.io/docs/start/). The documentation provides step-by-step instructions for installing Minikube on various operating systems.
4. Start the Minikube cluster by running the following command:
```
minikube start
```
This command will start the Minikube cluster with default configurations.
5. Check Connectivity to Minikube Cluster: After installing **kubectl** and starting **Minikube**, you can verify if **kubectl** is able to reach the **Minikube** cluster by running the following command:
```
kubectl cluster-info
```
This command should display information about the Minikube cluster, including the cluster endpoints and their status. If you see the cluster information, it means that kubectl is successfully communicating with the Minikube cluster. **Note**: Make sure you have started the Minikube cluster using minikube start before running the kubectl cluster-info command. If you encounter any issues or if the cluster information is not displayed, ensure that you have correctly installed kubectl and started the Minikube cluster.

Make sure to install these prerequisites before proceeding with using Minikube.

## How to Create Libera Infrastructure in your Local Minikube K8s Cluster from Scratch

To create the cluster, follow these steps:

1. Open your terminal and navigate to the root directory.
2. Execute the following command:

```
bash create-local-cluster
```

This script will set up a local Minikube cluster with default configurations.

To delete the cluster, follow these steps:

1. Open your terminal and navigate to the root directory.
2. Execute the following command:
```
bash delete-local-cluster
```

This script will delete the local Minikube cluster, removing all associated resources.

Note: Make sure you have fulfilled the prerequisites mentioned above before creating or deleting the local cluster.

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
