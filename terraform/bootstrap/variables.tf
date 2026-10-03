variable "aws_profile" {
  description = "AWS CLI profile created by aws login"
  type        = string
  default     = "hotaru"
}

variable "region" {
  description = "AWS region for the bootstrap resources"
  type        = string
  default     = "ap-northeast-1"
}
