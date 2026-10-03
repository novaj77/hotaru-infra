output "account_id" {
  description = "AWS account ID that Terraform operates on"
  value       = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  description = "ARN of the identity used by Terraform"
  value       = data.aws_caller_identity.current.arn
}

output "tfstate_bucket" {
  description = "S3 bucket name for Terraform remote state"
  value       = aws_s3_bucket.tfstate.bucket
}

output "tfstate_region" {
  description = "AWS region of the Terraform state bucket"
  value       = var.region
}
