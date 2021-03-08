# terraform/aws-es

Terraform configuration to provision an Amazon Elasticsearch cluster inside a VPC.

----

## What's in this folder
This Terraform configuration is based on the state-of-the-art [terraform-aws-elasticsearch](https://github.com/cloudposse/terraform-aws-elasticsearch) module maintained by Cloud Posse. In particular, this configuration will create:
- Amazon Elasticsearch cluster with the specified node count in the provided subnets of the specified VPC (`./main.tf`)
- Elasticsearch domain policy that accepts a list of IAM role ARNs from which to permit management traffic to the cluster (`./main.tf`)
- Security Group to control access to the Elasticsearch domain  (`./main.tf`)
- (optional) Cloudwatch Log Groups for publishing Elasticsearch application logs as well as index/search slow logs (`./cloudwatch.tf`)

## How to use this repo
The tfvars files collected in the `./clusters` folder allow specifing the exact configuration of a desired cluster. The list of variables is available in `./variables.tf`.

> The Terraform configuration in this repo currently uses the default `local` backend. Please configure a `remote` backend to operate this configuration in a team or to integrate it with CI/CD (see [Terraform documentation](https://www.terraform.io/docs/language/settings/backends/configuration.html)).

### Prerequisites
1. Install Terraform (see `./version.tf`). If you are using a Linux machine, it is recommended not to install Terraform from the Snap store; download and install the binaries from Hashicorp instead.
2. Install AWS CLI and configure it with your AWS account credentials. Note that Terraform will use the `default` AWS config profile, unless you specify a different profile in the `aws_profile` variable of the referenced tfvars.
3. A VPC is already created in the desired region of your AWS account and can be referenced.

### Provision a cluster using a tfvars file
```
$ cd path/to/aws-es-terraform/terraform/aws-es
```

The first time you use this repo, you need to initialize the working directory for use with Terraform.

```
$ terraform init
```

(optional) You can create dedicated [workspaces](https://www.terraform.io/docs/cli/workspaces/index.html) in your working directory, each with a separate instance of state data. This allows you to manage multiple groups of resources (e.g., for different environments) with the same configuration. For example, let's create a new workspace for `development`.

```
$ terraform workspace new development
# to verify you're in the right workspace
$ terraform workspace list
```

Create the *execution plan* for applying changes to the infrastructure. Note that this step won't apply any change yet, but will just fetch the current status and settings of the resources specified in the configuration, so that Terraform will know what actions are necessary to achieve the desired state.

This is the first step where you provide the `.tfvars` with the definition of the cluster you'd like to provision or update.

```
$ terraform plan -var-file="./clusters/sample-dev.tfvars"
```

The command will output the execution plan. Take the time to review the summary at the end (example below).

```
...
Plan: 7 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + domain_endpoint                 = (known after apply)
  + domain_name                     = "sample-dev"
  + elasticsearch_user_iam_role_arn = (known after apply)
  + security_group_id               = (known after apply)
```

If the plan step determined that some changes to the infrastructure are required to the achieve the desired state, then you can run the apply command. Note that you can use the `-auto-approve` option to skip the interactive approval in the command line.

```
$ terraform apply -var-file="./clusters/sample-dev.tfvars"
```

### Provision another cluster using this Terraform configuration
To operate different clusters using this configuration files, you can create multiple workspaces and switching between them. For example, you can provision two separate clusters for different environments by running the commands below.

```
$ cd path/to/aws-es-terraform/terraform/aws-es

# create 1st workspace
$ terraform workspace new dev
$ terraform plan -var-file="./clusters/sample-dev.tfvars"
$ terraform apply -var-file="./clusters/sample-dev.tfvars" -auto-approve

# create 2nd workspace
$ terraform workspace new prod
$ terraform plan -var-file="./clusters/sample-prod.tfvars"
$ terraform apply -var-file="./clusters/sample-prod.tfvars" -auto-approve

# show all the workspaces
$ terraform workspace list

# switch back to the 1st workspace
$ terraform workspace select dev
```

### Delete a cluster along with its resources
To delete the AWS resources associated with a cluster setup, you can use the `destroy` command. Note that you can only delete infrastructure managed by Terraform, i.e., the ones in the Terraform state. The `-auto-approve` option to skip interactive approval in available also for destroy.

```
$ terraform destroy -var-file="./clusters/sample-dev.tfvars"
```
