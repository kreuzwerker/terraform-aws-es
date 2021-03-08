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

# domain name
variable "namespace" {
  type        = string
  default     = ""
  description = "Namespace value used to generate domain name"
}

variable "stage" {
  type        = string
  default     = "dev"
  description = "Stage/Environment value used to generate domain name"
}

variable "name" {
  type        = string
  default     = "es"
  description = "Unique name of the application used to generate domain name"
}

# iam
variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "ID of the security group"
}

variable "create_iam_service_linked_role" {
  type        = bool
  default     = false
  description = "Whether to create `AWSServiceRoleForAmazonElasticsearchService` service-linked role. Set it to `false` if you already have an ElasticSearch cluster created in the AWS account and AWSServiceRoleForAmazonElasticsearchService already exists"
}

variable "iam_actions" {
  type        = list(string)
  default     = []
  description = "List of actions to allow for the IAM roles, e.g. es:ESHttpGet, es:ESHttpPut, es:ESHttpPost"
}

variable "iam_role_arns" {
  type        = list(string)
  default     = []
  description = "List of IAM role ARNs to permit access to the Elasticsearch domain"
}

# network
variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "IDs of the private subnets"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "List of CIDR blocks to be allowed to connect to the cluster"
}

# elasticsearch
variable "elasticsearch_version" {
  type        = string
  description = "Version of Elasticsearch to deploy"
}

variable "instance_type" {
  type        = string
  default     = "t3.small.elasticsearch"
  description = "The type of the instance"
}

variable "instance_count" {
  type        = number
  default     = 1
  description = "Number of data nodes in the cluster"
}

variable "dedicated_master_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether dedicated master nodes are enabled for the cluster"
}

variable "dedicated_master_count" {
  type        = number
  default     = 0
  description = "Number of dedicated master nodes in the cluster"
}

variable "dedicated_master_type" {
  type        = string
  default     = ""
  description = "Instance type of the dedicated master nodes in the cluster"
}

variable "warm_enabled" {
  type        = bool
  default     = false
  description = "Whether AWS UltraWarm is enabled"
}

variable "warm_count" {
  type        = number
  default     = 0
  description = "Number of UltraWarm nodes"
}

variable "warm_type" {
  type        = string
  default     = "ultrawarm1.medium.elasticsearch"
  description = "Type of UltraWarm nodes"
}

# dns
variable "dns_zone_id" {
  type        = string
  default     = ""
  description = "Route53 DNS Zone ID to add hostname records for Elasticsearch domain and Kibana"
}

variable "domain_hostname_enabled" {
  type        = bool
  default     = false
  description = "Explicit flag to enable creating a DNS hostname for ES. If true, then var.dns_zone_id is required."
}

variable "kibana_hostname_enabled" {
  type        = bool
  default     = false
  description = "Explicit flag to enable creating a DNS hostname for Kibana. If true, then var.dns_zone_id is required."
}

variable "elasticsearch_subdomain_name" {
  type        = string
  default     = ""
  description = "The name of the subdomain for Elasticsearch in the DNS zone (_e.g._ elasticsearch, ui, ui-es, search-ui)"
}

variable "kibana_subdomain_name" {
  type        = string
  default     = ""
  description = "The name of the subdomain for Kibana in the DNS zone"
}

# disks
variable "ebs_volume_size" {
  type        = number
  default     = 10
  description = "EBS volumes for data storage in GB"
}

variable "ebs_volume_type" {
  type        = string
  default     = "gp2"
  description = "Storage type of EBS volumes"
}

# security
variable "domain_endpoint_options_enforce_https" {
  type        = bool
  default     = true
  description = "Whether or not to require HTTPS"
}

variable "domain_endpoint_options_tls_security_policy" {
  type        = string
  default     = "Policy-Min-TLS-1-0-2019-07"
  description = "The name of the TLS security policy that needs to be applied to the HTTPS endpoint"
}

variable "encrypt_at_rest_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable encryption at rest"
}

variable "encrypt_at_rest_kms_key_id" {
  type        = string
  default     = ""
  description = "The KMS key ID to encrypt the Elasticsearch domain with. If not specified, then it defaults to using the AWS/Elasticsearch service KMS key"
}

# logs
variable "logs_retention_in_days" {
  type        = number
  default     = 0
  description = "Specifies the number of days you want to retain log events in the specified log group"
}

variable "log_publishing_index_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether log publishing option for INDEX_SLOW_LOGS is enabled or not"
}

variable "log_publishing_search_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether log publishing option for SEARCH_SLOW_LOGS is enabled or not"
}

variable "log_publishing_application_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether log publishing option for ES_APPLICATION_LOGS is enabled or not"
}

# others
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map('BusinessUnit','XYZ')"
}