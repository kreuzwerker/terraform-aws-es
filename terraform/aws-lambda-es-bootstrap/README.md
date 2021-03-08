# terraform/aws-lambda-es-bootstrap

Terraform configuration to bootstrap data into an Amazon Elasticsearch cluster running in a VPC. The bootstrapping mechanism consists in [restoring a snapshot](https://opendistro.github.io/for-elasticsearch-docs/docs/elasticsearch/snapshot-restore/) into the cluster from an existing S3 snapshot repository.

----

## What's in this repo
This Terraform configuration will create:
- AWS Lambda function to restore a snapshot into a running Amazon Elasticsearch cluster.
- IAM policies to grant the Lambda function access to the Amazon Elasticsearch cluster.
- IAM policies to delegate Amazon Elasticsearch permissions to access the S3 bucket used as a snapshot repository.

## How to use this repo
To use this Terraform configuration you need to set the variables listed in `./variables.tf`. For convenience, you can set the variables by using the `./setup.tfvars` file in this folder and reference it when running the Terraform commands.

> The Terraform configuration in this repo currently uses the default `local` backend. Please configure a `remote` backend to operate this configuration in a team or to integrate it with CI/CD (see [Terraform documentation](https://www.terraform.io/docs/language/settings/backends/configuration.html)).

### Prerequisites
1. Install Terraform (see `./version.tf`). If you are using a Linux machine, it is recommended not to install Terraform from the Snap store; download and install the binaries from Hashicorp instead.
2. Install AWS CLI and configure it with your AWS account credentials. Note that Terraform will use the `default` AWS config profile, unless you specify a different profile in the `aws_profile` variable of the referenced tfvars.
3. An Amazon Elasticsearch cluster is already running in the desired region of your AWS account.
4. An S3 bucket used as snapshot repository already exists.
5. The name of the snapshot to restore from the S3 snapshot repository is known.

### Provision the lambda
```
$ cd path/to/aws-es-terraform/terraform/aws-lambda-es-bootstrap
```

The first time you use this repo, you need to initialize the working directory for use with Terraform.

```
$ terraform init
```

Create the *execution plan* for applying changes to the infrastructure. Note that this step won't apply any change yet, but will just fetch the current status and settings of the resources specified in the configuration, so that Terraform will know what actions are necessary to achieve the desired state.

This is the first step where you provide the `.tfvars` with the settings of the Lambda you'd like to provision or update.

```
$ terraform plan -var-file="./setup.tfvars"
```

The command will output the execution plan. Take the time to review the summary at the end (example below).

```
...
Plan: 9 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + domain_endpoint                 = (known after apply)
  + domain_name                     = "test-1-dev"
  + elasticsearch_user_iam_role_arn = (known after apply)
  + security_group_id               = (known after apply)
```

If the plan step determined that some changes to the infrastructure are required to the achieve the desired state, then you can run the apply command. Note that you can use the `-auto-approve` option to skip the interactive approval in the command line.

```
$ terraform apply -var-file="./setup.tfvars"
```

### Trigger the lambda to bootstrap data
To trigger the Lambda and bootstrap data from the S3 snapshot repository into the specified Amazon Elasticsearch cluster, you can run twice the `lambda invoke` command of the [AWS CLI](https://aws.amazon.com/cli/): the first time to register the snapshot repository on the new cluster, the second time to restore the provided snapshot.

```
# register the snapshot repository
$ aws lambda invoke --function-name "es_bootstrap_from_snapshot" out --log-type Tail
# restore the snapshot
$ aws lambda invoke --function-name "es_bootstrap_from_snapshot" out --log-type Tail
```

### Delete a lambda along with its resources
To delete the AWS resources associated with a lambda setup, you can use the `destroy` command. Note that you can only delete infrastructure managed by Terraform, i.e., the ones in the Terraform state. The `-auto-approve` option to skip interactive approval in available also for destroy.

```
$ terraform destroy -var-file="./setup.tfvars"
```

### Change the Lambda code
The codebase of the Lambda function is stored in the `./lambda` folder. Every time you edit the code, run the `./build.sh` script to create the new archive to upload to AWS via Terraform. Then, you can run the Terraform apply command.