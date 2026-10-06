variable "aws_profile" {
  description = "AWS CLI profile created by aws login"
  type        = string
  default     = "hotaru"
}

variable "region" {
  description = "AWS region for the cluster resources"
  type        = string
  default     = "ap-northeast-1"
}

variable "vpc_cidr" {
  description = "CIDR block of the hotaru VPC"
  type        = string
  default     = "10.10.0.0/16"
}
