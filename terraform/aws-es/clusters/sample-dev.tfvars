# domain name
name  = "sample"
stage = "dev"
# iam
iam_actions                    = ["es:*"]
iam_role_arns                  = ["*"]
# network
vpc_id     = "your_vpc_id"
subnet_ids = ["your_1st_subnet_id"]
# elasticsearch
elasticsearch_version = "7.9"