locals {
  github_deploy_repository_sub = "repo:${var.github_owner}@${var.github_owner_id}/${var.github_deploy_repository.name}@${var.github_deploy_repository.id}:ref:refs/heads/main"
}

data "aws_iam_policy_document" "hotaru_deploy_ci_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [local.github_deploy_repository_sub]
    }
  }
}

resource "aws_iam_role" "hotaru_deploy_ci" {
  name                 = "hotaru-deploy-github-actions"
  description          = "Assumed by GitHub Actions on the main branch of hotaru-deploy to deploy hotaru-api to the hotaru cluster"
  assume_role_policy   = data.aws_iam_policy_document.hotaru_deploy_ci_trust.json
  max_session_duration = 3600
}
