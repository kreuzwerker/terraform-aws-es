resource "aws_cloudwatch_log_group" "aes_index" {
  count             = var.log_publishing_index_enabled ? 1 : 0
  name              = "/aws/aes/domains/${var.name}-${var.stage}/index-logs"
  retention_in_days = var.logs_retention_in_days
}

resource "aws_cloudwatch_log_group" "aes_search" {
  count             = var.log_publishing_search_enabled ? 1 : 0
  name              = "/aws/aes/domains/${var.name}-${var.stage}/search-logs"
  retention_in_days = var.logs_retention_in_days
}

resource "aws_cloudwatch_log_group" "aes_application" {
  count             = var.log_publishing_application_enabled ? 1 : 0
  name              = "/aws/aes/domains/${var.name}-${var.stage}/application-logs"
  retention_in_days = var.logs_retention_in_days
}

data "aws_iam_policy_document" "es_logs" {
  statement {
    sid = "1"

    actions = [
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
      "logs:CreateLogStream"
    ]

    resources = [
      "arn:aws:logs:*"
    ]

    principals {
      type = "Service"
      identifiers = [
        "es.amazonaws.com"
      ]
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "es" {
  policy_name     = "${var.name}-${var.stage}-es-logs-policy"
  policy_document = data.aws_iam_policy_document.es_logs.json
}
