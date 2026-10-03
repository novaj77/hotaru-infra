data "aws_caller_identity" "current" {}

locals {
  tfstate_bucket_name = "hotaru-tfstate-${data.aws_caller_identity.current.account_id}-${var.region}"
}
