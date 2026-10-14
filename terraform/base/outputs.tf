output "hotaru_api_ecr_repository_url" {
  description = "ECR repository URL for hotaru-api images"
  value       = aws_ecr_repository.hotaru_api.repository_url
}

output "hotaru_api_ci_role_arn" {
  description = "IAM role ARN assumed by GitHub Actions in hotaru-api (role-to-assume)"
  value       = aws_iam_role.hotaru_api_ci.arn
}

output "github_oidc_provider_arn" {
  description = "ARN of the GitHub Actions OIDC provider"
  value       = aws_iam_openid_connect_provider.github.arn
}

output "alb_controller_role_arn" {
  description = "IAM role ARN for AWS Load Balancer Controller (EKS Pod Identity)"
  value       = aws_iam_role.alb_controller.arn
}

output "cluster_autoscaler_role_arn" {
  description = "IAM role ARN for Cluster Autoscaler (EKS Pod Identity)"
  value       = aws_iam_role.cluster_autoscaler.arn
}

output "hosted_zone_name_servers" {
  description = "Name servers of the public hosted zone"
  value       = data.aws_route53_zone.main.name_servers
}

output "acm_certificate_arn" {
  description = "ACM certificate for the domain and its wildcard (discovered by AWS Load Balancer Controller)"
  value       = aws_acm_certificate_validation.main.certificate_arn
}

output "external_dns_role_arn" {
  description = "IAM role ARN for external-dns (EKS Pod Identity)"
  value       = aws_iam_role.external_dns.arn
}

output "hotaru_deploy_ci_role_arn" {
  description = "IAM role ARN assumed by GitHub Actions on the main branch of hotaru-deploy"
  value       = aws_iam_role.hotaru_deploy_ci.arn
}

output "vpc_id" {
  description = "ID of the hotaru VPC"
  value       = aws_vpc.hotaru.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs keyed by availability zone"
  value       = { for az, subnet in aws_subnet.public : az => subnet.id }
}

output "hotaru_cluster_ci_role_arn" {
  description = "IAM role ARN assumed by GitHub Actions on the main branch of hotaru-infra to start and stop the cluster"
  value       = aws_iam_role.hotaru_cluster_ci.arn
}
