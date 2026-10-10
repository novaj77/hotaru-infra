variable "region" {
  description = "AWS region for the cluster resources"
  type        = string
  default     = "ap-northeast-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "hotaru"
}

variable "kubernetes_version" {
  description = "Kubernetes version of the EKS cluster"
  type        = string
  default     = "1.36"
}

variable "cluster_admin_role_name" {
  description = "IAM role granted cluster admin through an EKS access entry"
  type        = string
  default     = "AccountFullAccessRole"
}
