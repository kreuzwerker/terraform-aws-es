provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

module "elasticsearch" {
  source  = "cloudposse/elasticsearch/aws"
  version = "0.26.0"

  # domain name
  label_order = ["namespace", "name", "stage"]
  namespace   = var.namespace
  name        = var.name
  stage       = var.stage
  # iam
  security_groups                = var.security_group_ids
  create_iam_service_linked_role = var.create_iam_service_linked_role
  iam_actions                    = var.iam_actions
  iam_role_arns                  = var.iam_role_arns
  # network
  vpc_id                  = var.vpc_id
  subnet_ids              = var.subnet_ids
  zone_awareness_enabled  = (length(var.subnet_ids) > 1)
  availability_zone_count = length(var.subnet_ids)
  # elasticsearch
  elasticsearch_version    = var.elasticsearch_version
  instance_type            = var.instance_type
  instance_count           = var.instance_count
  dedicated_master_enabled = var.dedicated_master_enabled
  dedicated_master_count   = var.dedicated_master_count
  dedicated_master_type    = var.dedicated_master_type
  warm_enabled             = var.warm_enabled
  warm_count               = var.warm_count
  warm_type                = var.warm_type
  # dns
  dns_zone_id                  = var.dns_zone_id
  domain_hostname_enabled      = var.domain_hostname_enabled
  kibana_hostname_enabled      = var.kibana_hostname_enabled
  elasticsearch_subdomain_name = var.elasticsearch_subdomain_name
  kibana_subdomain_name        = var.kibana_subdomain_name
  # disks
  ebs_volume_size = var.ebs_volume_size
  ebs_volume_type = var.ebs_volume_type
  # logs
  log_publishing_index_cloudwatch_log_group_arn       = var.log_publishing_index_enabled ? aws_cloudwatch_log_group.aes_index.*.arn[0] : ""
  log_publishing_search_cloudwatch_log_group_arn      = var.log_publishing_search_enabled ? aws_cloudwatch_log_group.aes_search.*.arn[0] : ""
  log_publishing_application_cloudwatch_log_group_arn = var.log_publishing_application_enabled ? aws_cloudwatch_log_group.aes_application.*.arn[0] : ""
  log_publishing_index_enabled                        = var.log_publishing_index_enabled
  log_publishing_search_enabled                       = var.log_publishing_search_enabled
  log_publishing_application_enabled                  = var.log_publishing_application_enabled
  # security
  domain_endpoint_options_enforce_https       = var.domain_endpoint_options_enforce_https || var.master_user_name != ""
  domain_endpoint_options_tls_security_policy = var.domain_endpoint_options_tls_security_policy
  node_to_node_encryption_enabled             = var.node_to_node_encryption_enabled
  encrypt_at_rest_enabled                     = var.encrypt_at_rest_enabled || var.master_user_name != ""
  encrypt_at_rest_kms_key_id                  = var.encrypt_at_rest_kms_key_id
  # open distro security plugin
  advanced_security_options_enabled                        = var.master_user_name != ""
  advanced_security_options_internal_user_database_enabled = var.master_user_name != ""
  advanced_security_options_master_user_name               = var.master_user_name
  advanced_security_options_master_user_password           = var.master_user_password
  # others
  tags = var.tags
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }
}

resource "aws_security_group_rule" "ingress_cidr_blocks" {
  description       = "Allow inbound traffic from CIDR blocks"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["192.168.0.0/16", "10.0.0.0/8", "172.0.0.0/8"]
  security_group_id = module.elasticsearch.security_group_id
}