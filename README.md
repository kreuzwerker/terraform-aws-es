# aws-es-terraform

Terraform configurations to launch an Amazon Elasticsearch cluster in a VPC.

---
## Quick starts
> ... [0. Prerequisites](#0-prerequisites) \
> ... [1. How to provision an Amazon Elasticsearch cluster](#1-how-to-provision-an-amazon-elasticsearch-cluster) \
> ... [2. How to bootstrap data into an Amazon Elasticsearch cluster](#2-how-to-bootstrap-data-into-an-amazon-elasticsearch-cluster)

### 0. Prerequisites
1. Install Terraform >= v0.13. If you are using a Linux machine, do not install Terraform from the Snap store, but download and install the binaries from Hashicorp instead.
2. Install AWS CLI and configure it with your your AWS account credentials. Note that Terraform will use the `default` AWS config profile and `eu-central-1` region by default.
3. A VPC is already created in the desired region of your AWS account and can be referenced.

### 1. How to provision an Amazon Elasticsearch cluster
```
$ cd path/to/aws-es-terraform/terraform/aws-es
$ terraform init
```

Create a `.tfvars` file to specify the desired settings of the new Amazon Elasticsearch cluster, such as the name, number and type of nodes, access policies, and logs to enable. The settings supported by this Terraform configuration are listed in [the variables file](./terraform/aws-es/variables.tf). Sample tfvars files are available in [this folder](./terraform/aws-es/clusters).

Use the desired tfvars file to create the Terraform *execution plan* that prepares the list of changes to apply to the existing infrastructure. Finally, apply the execution plan and create or update the resources to spin up the Amazon Elasticsearch cluster.

```
$ terraform plan -var-file="desired-configuration.tfvars"
$ terraform apply -var-file="desired-configuration.tfvars"
```

> For more detailed information on how to create, update, and delete an Amazon Elasticsearch cluster using this Terraform configuration, please refer to the specific [`README.md`](./terraform/aws-es/README.md).

### 2. How to bootstrap data into an Amazon Elasticsearch cluster
The bootstrapping mechanism consists in [restoring a snapshot](https://opendistro.github.io/for-elasticsearch-docs/docs/elasticsearch/snapshot-restore/) into the cluster from an existing S3 snapshot repository.

> Additional prerequisites:
> 1. The target Amazon Elasticsearch cluster is already running in the desired region of your AWS account.
> 2. An S3 bucket used as a snapshot repository already exists.
> 3. The name of the snapshot to restore from the S3 snapshot repository is known.

```
$ cd path/to/aws-es-terraform/terraform/aws-lambda-es-bootstrap
$ terraform init
```

Create a `.tfvars` file to configure the Lambda. The required settings, listed in [the variables file](./terraform/aws-lambda-es-bootstrap/variables.tf), include the coordinates of the cluster (domain, ARN, subnet, and security group), name of the S3 bucket used as snapshot repository, and the name of the snapshot to restore. A sample tfvars file is available [here](./terraform/aws-lambda-es-bootstrap/setup.tfvars).

Use the desired tfvars file to create the Terraform *execution plan*, and apply it to create or update the resources to spin up the Lambda function.

```
$ terraform plan -var-file="desired-configuration.tfvars"
$ terraform apply -var-file="desired-configuration.tfvars"
```

Finally, you can execute the Lambda by running twice the [AWS CLI](https://aws.amazon.com/cli/) commands below.

```
# register the snapshot repository
$ aws lambda invoke --function-name "es_bootstrap_from_snapshot" out --log-type Tail
# restore the snapshot
$ aws lambda invoke --function-name "es_bootstrap_from_snapshot" out --log-type Tail
```

> For more detailed information on how to create, update, and delete the Lambda function using this Terraform configuration, please refer to the specific [`README.md`](./terraform/aws-lambda-es-bootstrap/README.md).