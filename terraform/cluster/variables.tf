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

variable "public_subnets" {
  description = "Public subnet CIDR blocks keyed by availability zone"
  type        = map(string)
  default = {
    "ap-northeast-1a" = "10.10.0.0/20"
    "ap-northeast-1c" = "10.10.16.0/20"
  }
}
