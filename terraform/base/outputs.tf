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
