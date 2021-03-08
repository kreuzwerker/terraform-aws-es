variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "AWS region"
}

variable "aws_profile" {
  type        = string
  default     = "default"
  description = "AWS Profile that contains credentials to connect to AWS"
}

# Elasticsearch domain
variable "es_domain_arn" {
  type        = string
  description = "The Elasticsearch domain ARN"
}

variable "es_domain_endpoint" {
  type        = string
  description = "The Elasticsearch domain endpoint"
}

variable "es_security_group_id" {
  type        = string
  description = "The Elasticsearch cluster security group IDs"
}

variable "es_subnet_ids" {
  type        = list(string)
  description = "IDs of the private subnets where the Elasticsearch cluster is deployed"
}

# Snapshot repository
variable "s3_repository_bucket" {
  type        = string
  default     = ""
  description = "The name of the s3 bucket that hosts the Elasticsearch snapshot repository"
}

variable "es_snapshot_repository" {
  type        = string
  default     = "bootstrap-repo"
  description = "The name of the snapshot repository with the data to bootstrap"
}

variable "es_snapshot_name" {
  type        = string
  description = "The name of the snapshot to restore"
}

# others
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map('BusinessUnit','XYZ')"
}