output "security_group_id" {
  value       = join("", aws_lambda_function.es-bootstrap-lambda.*.id)
  description = "Security Group ID of the Lambda Function"
}

output "lambda_function_arn" {
  value       = join("", aws_lambda_function.es-bootstrap-lambda.*.arn)
  description = "ARN of the Lambda Function"
}

output "lambda_function_source_code_size" {
  value       = join("", aws_lambda_function.es-bootstrap-lambda.*.source_code_size)
  description = "The size in bytes of the function .zip file"
}