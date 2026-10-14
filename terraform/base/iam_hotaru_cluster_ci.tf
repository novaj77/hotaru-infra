locals {
  github_infra_repository_sub = "repo:${var.github_owner}@${var.github_owner_id}/${var.github_infra_repository.name}@${var.github_infra_repository.id}:ref:refs/heads/main"
  tfstate_bucket_arn          = "arn:aws:s3:::hotaru-tfstate-${data.aws_caller_identity.current.account_id}-${var.region}"
  cluster_state_object_arn    = "${local.tfstate_bucket_arn}/cluster/terraform.tfstate"
  eks_arn_prefix              = "arn:aws:eks:${var.region}:${data.aws_caller_identity.current.account_id}"
  hotaru_cluster_arn          = "${local.eks_arn_prefix}:cluster/${var.eks_cluster_name}"
}

data "aws_iam_policy_document" "hotaru_cluster_ci_trust" {
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
      values   = [local.github_infra_repository_sub]
    }
  }
}

resource "aws_iam_role" "hotaru_cluster_ci" {
  name                 = "hotaru-cluster-github-actions"
  description          = "Assumed by GitHub Actions on the main branch of hotaru-infra to start and stop the hotaru cluster"
  assume_role_policy   = data.aws_iam_policy_document.hotaru_cluster_ci_trust.json
  max_session_duration = 3600
}

data "aws_iam_policy_document" "hotaru_cluster_ci" {
  statement {
    sid       = "ListStateBucket"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [local.tfstate_bucket_arn]
  }

  statement {
    sid       = "ReadWriteClusterState"
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = [local.cluster_state_object_arn]
  }

  statement {
    sid       = "LockClusterState"
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${local.cluster_state_object_arn}.tflock"]
  }

  statement {
    sid       = "CreateHotaruCluster"
    effect    = "Allow"
    actions   = ["eks:CreateCluster"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/Project"
      values   = ["hotaru"]
    }

    condition {
      test     = "Bool"
      variable = "eks:bootstrapClusterCreatorAdminPermissions"
      values   = ["false"]
    }

    condition {
      test     = "StringEquals"
      variable = "eks:supportType"
      values   = ["STANDARD"]
    }
  }

  statement {
    sid       = "ReadAndDeleteHotaruCluster"
    effect    = "Allow"
    actions   = ["eks:DescribeCluster", "eks:DeleteCluster"]
    resources = [local.hotaru_cluster_arn]
  }
}
