# Free Oracle Kubernetes with Terraform

## OCI Configuration
```
oci setup config
```

## Setting up the Terraform variables

### Set Environment Variables
```
export TF_VAR_compartment_id=<your compartment ocid>
export TF_VAR_region=<your region>
export TF_VAR_ssh_public_key=<your public key>
```

### Set Terraform variables in terraform.tfvars
```
compartment_id = <your compartment ocid>
region = <your region>
ssh_public_key = <your public key>
```

## Deploy Kubernetes Cluster
```
# Initialize
terraform init

# Review resources to be deployed
terraform plan

# Apply changes for deploy
terraform apply
```


## Getting access to the Kubernetes cluster

Create kubeconfig file for kubectl to access the cluster
```
oci ce cluster create-kubeconfig --cluster-id <cluster OCID> --file ~/.kube/k8s-config --region <region> --token-version 2.0.0 --kube-endpoint PUBLIC_ENDPOINT
```

This will create a k8s-config file in the ~/.kube folder that contains the keys and all the configuration for kubectl to access the cluster.

Set this configuration through the KUBECONFIG environment variable for kubectl.

```
export KUBECONFIG=~/.kube/k8s-config
```

Try to list the available nodes in the cluster.

```
kubectl get nodes
```

The cluster is ready when nool pool has been provisioned and has 2 nodes.


# Exposing apps from an Oracle Kubernetes cluster using a Network Load Balancer 

## Preparing for deployment

### Setting up the Terraform variables

#### Set Environment Variables
```
export TF_VAR_compartment_id=<your compartment ocid>
export TF_VAR_region=<your region>
export TF_VAR_ssh_public_key=<your public key>
export TF_VAR_node_pool_id=<your node pool's ocid>
```

#### Set Terraform variables in terraform.tfvars
```
compartment_id = <your compartment ocid>
region = <your region>
ssh_public_key = <your public key>
node_pool_id=<your node pool's ocid>
```

## Deploy Application
```
# Initialize
terraform init

# Review resources to be deployed
terraform plan

# Apply changes for deploy
terraform apply
```

Access the application with public IP address.


# GitHub Actions CI/CD for Oracle Cloud Kubernetes

## Create Docker App

Create custom index.html file
```
<!DOCTYPE html>
<html>
    <head>
        <title>Free Kubernetes</title>
    </head>
    <body>
        <h1>This is a custom page running on a Free Kubernetes cluster on Oracle Cloud</h1>
        <h1>Also, there's a free CICD pipeline included using GitHub Actions</h1>
    </body>
</html>
```

Create docker file
```
FROM nginx:latest
COPY index.html /usr/share/nginx/html/index.html
```

Create and Run docker image
```
docker build -t kubernetes-nginx .

docker run -p 80:80 kubernetes-nginx
```

## OCI Docker Login

- The username for the registry comes together from those 2 in the form of <object-storage-namespace>/<username> so for example it could be abcdefgh/test123.
- Docker server is [available by region](https://docs.oracle.com/en-us/iaas/Content/Registry/Concepts/registryprerequisites.htm#Preparing_for_Registry)
- Go to user’s details on the cloud console and select Auth Tokens to generate Auth Tokens for programmatic access to the registry.

```
docker login -u <object-storage-namespace>/<username> <docker server>

#Example
docker login -u abcdefgh/test123 https://us-ashburn-1.ocir.io
```

## Create Kubernetes Secret

```
kubectl -n <namespace> create secret docker-registry registry-secret --docker-server=<docker-server> --docker-username='<object-storage-namespace>/<username>' --docker-password='<password>'
```

## Automatic building and deployment
