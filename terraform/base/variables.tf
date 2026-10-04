variable "aws_profile" {
  description = "AWS CLI profile created by aws login"
  type        = string
  default     = "hotaru"
}

variable "region" {
  description = "AWS region for the base resources"
  type        = string
  default     = "ap-northeast-1"
}

variable "github_owner" {
  description = "GitHub account that owns the hotaru repositories"
  type        = string
  default     = "novaj77"
}

variable "github_owner_id" {
  description = "Immutable numeric ID of the GitHub account"
  type        = number
  default     = 335673622
}

variable "github_api_repository" {
  description = "Name and immutable numeric ID of the hotaru-api repository"
  type = object({
    name = string
    id   = number
  })
  default = {
    name = "hotaru-api"
    id   = 1396450276
  }
}
