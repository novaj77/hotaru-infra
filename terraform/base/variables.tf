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

variable "github_deploy_repository" {
  description = "Name and immutable numeric ID of the hotaru-deploy repository"
  type = object({
    name = string
    id   = number
  })
  default = {
    name = "hotaru-deploy"
    id   = 1396474533
  }
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster created by the cluster stack"
  type        = string
  default     = "hotaru"
}

variable "domain_name" {
  description = "Domain registered with Route 53 Domains (its public hosted zone is created by the registration)"
  type        = string
  default     = "hotaru-novaj.click"
}
