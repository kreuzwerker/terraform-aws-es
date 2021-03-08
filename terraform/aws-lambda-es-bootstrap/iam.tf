data "aws_iam_policy_document" "es_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["es.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "access_s3_repository" {
  statement {
    actions   = ["s3:GetObject"]
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.s3_repository_bucket}/*"]
  }

  statement {
    actions   = ["s3:ListBucket"]
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.s3_repository_bucket}"]
  }
}

resource "aws_iam_role" "es_snapshot_role" {
  name               = "es_snapshot_role"
  assume_role_policy = data.aws_iam_policy_document.es_assume.json
  tags               = var.tags
}

resource "aws_iam_role_policy" "es_snapshot_role_policy" {
  name   = "access_s3_repository_policy"
  role   = aws_iam_role.es_snapshot_role.name
  policy = data.aws_iam_policy_document.access_s3_repository.json
}

data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_access_es" {
  statement {
    actions   = ["iam:PassRole"]
    effect    = "Allow"
    resources = [aws_iam_role.es_snapshot_role.arn]
  }

  statement {
    actions   = ["es:ESHttpPost", "es:ESHttpPut", "es:ESHttpGet"]
    effect    = "Allow"
    resources = [var.es_domain_arn, "${var.es_domain_arn}/*"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "es_bootstrap_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
  tags               = var.tags
}

resource "aws_iam_role_policy" "lambda_role_policy" {
  name   = "es_bootstrap_lambda_policy"
  role   = aws_iam_role.lambda_role.name
  policy = data.aws_iam_policy_document.lambda_access_es.json
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
