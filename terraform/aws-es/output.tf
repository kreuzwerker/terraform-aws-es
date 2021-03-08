output "domain_name" {
  value       = module.elasticsearch.domain_name
  description = "Name of the Elasticsearch domain"
}

output "domain_endpoint" {
  value       = module.elasticsearch.domain_endpoint
  description = "Domain-specific endpoint used to submit index, search, and data upload requests"
}

output "domain_arn" {
  value       = module.elasticsearch.domain_arn
  description = "ARN of the Elasticsearch domain"
}

output "security_group_id" {
  value       = module.elasticsearch.security_group_id
  description = "Security Group ID to control access to the Elasticsearch domain"
}

output "elasticsearch_user_iam_role_arn" {
  value       = module.elasticsearch.elasticsearch_user_iam_role_arn
  description = "The ARN of the IAM role to allow access to Elasticsearch cluster"
}