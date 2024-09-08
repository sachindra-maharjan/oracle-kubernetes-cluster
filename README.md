# OCI Configuration
```
oci setup config
```

# Terraform 

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

### Deploy Kubernetes Cluster
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
oci ce cluster create-kubeconfig --cluster-id <cluster OCID> --file ~/.kube/free-k8s-config --region <region> --token-version 2.0.0 --kube-endpoint PUBLIC_ENDPOINT
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
