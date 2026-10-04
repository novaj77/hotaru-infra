locals {
  github_api_repository_sub = "repo:${var.github_owner}@${var.github_owner_id}/${var.github_api_repository.name}@${var.github_api_repository.id}:ref:refs/heads/main"
}

data "aws_iam_policy_document" "hotaru_api_ci_trust" {
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
      values   = [local.github_api_repository_sub]
    }
  }
}

resource "aws_iam_role" "hotaru_api_ci" {
  name                 = "hotaru-api-github-actions"
  description          = "Assumed by GitHub Actions on the main branch of hotaru-api to push images to ECR"
  assume_role_policy   = data.aws_iam_policy_document.hotaru_api_ci_trust.json
  max_session_duration = 3600
}

data "aws_iam_policy_document" "hotaru_api_ci_ecr" {
  statement {
    sid       = "GetAuthorizationToken"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid    = "PushAndPullHotaruApi"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
    ]
    resources = [aws_ecr_repository.hotaru_api.arn]
  }
}

resource "aws_iam_role_policy" "hotaru_api_ci_ecr" {
  name   = "ecr-push-pull"
  role   = aws_iam_role.hotaru_api_ci.id
  policy = data.aws_iam_policy_document.hotaru_api_ci_ecr.json
}
