# domain name
name  = "sample"
stage = "prod"
# iam
iam_actions                    = ["es:*"]
iam_role_arns                  = ["*"]
# network
vpc_id     = "your_vpc_id"
subnet_ids = ["your_1st_subnet_id", "your_2nd_subnet_id", "your_3rd_subnet_id"]
# elasticsearch
elasticsearch_version = "7.9"
instance_type            = "r5.4xlarge.elasticsearch"
instance_count           = 9
dedicated_master_enabled = true
dedicated_master_count   = 3
dedicated_master_type    = "c5.large.elasticsearch"
# disks
ebs_volume_size = 1000
# security
domain_endpoint_options_enforce_https = true
encrypt_at_rest_enabled               = true
# logs
log_publishing_index_enabled = true
log_publishing_search_enabled = true
log_publishing_application_enabled = true