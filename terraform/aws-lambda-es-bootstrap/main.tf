provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

data "local_file" "lambda_code_archive" {
  filename = "${path.module}/es-bootstrap-lambda.zip"
}

resource "aws_lambda_function" "es-bootstrap-lambda" {
  description      = "Restore data from a S3 Snapshot Repository into Elasticsearch"
  function_name    = "es_bootstrap_from_snapshot"
  role             = aws_iam_role.lambda_role.arn
  filename         = data.local_file.lambda_code_archive.filename
  source_code_hash = data.local_file.lambda_code_archive.content_base64
  handler          = "es-bootstrap.lambda_handler"
  runtime          = "python3.7"
  timeout          = 60

  environment {
    variables = {
      ES_ENDPOINT    = var.es_domain_endpoint
      ES_REGION      = var.region
      S3_REPO_BUCKET = var.s3_repository_bucket
      REPO_NAME      = var.es_snapshot_repository
      SNAPSHOT_NAME  = var.es_snapshot_name
      ROLE_ARN       = aws_iam_role.es_snapshot_role.arn
    }
  }

  vpc_config {
    subnet_ids         = var.es_subnet_ids
    security_group_ids = [var.es_security_group_id]
  }
}
