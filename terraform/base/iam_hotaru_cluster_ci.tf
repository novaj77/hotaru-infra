locals {
  github_infra_repository_sub    = "repo:${var.github_owner}@${var.github_owner_id}/${var.github_infra_repository.name}@${var.github_infra_repository.id}:ref:refs/heads/main"
  tfstate_bucket_arn             = "arn:aws:s3:::hotaru-tfstate-${data.aws_caller_identity.current.account_id}-${var.region}"
  cluster_state_object_arn       = "${local.tfstate_bucket_arn}/cluster/terraform.tfstate"
  eks_arn_prefix                 = "arn:aws:eks:${var.region}:${data.aws_caller_identity.current.account_id}"
  hotaru_cluster_arn             = "${local.eks_arn_prefix}:cluster/${var.eks_cluster_name}"
  eks_nodegroup_service_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/eks-nodegroup.amazonaws.com/AWSServiceRoleForAmazonEKSNodegroup"
}

data "aws_iam_role" "cluster_admin" {
  name = var.cluster_admin_role_name
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

  statement {
    sid    = "ManageHotaruNodegroups"
    effect = "Allow"
    actions = [
      "eks:CreateNodegroup",
      "eks:DescribeNodegroup",
      "eks:DeleteNodegroup",
    ]
    resources = [
      local.hotaru_cluster_arn,
      "${local.eks_arn_prefix}:nodegroup/${var.eks_cluster_name}/*",
    ]
  }

  statement {
    sid    = "ManageHotaruAddons"
    effect = "Allow"
    actions = [
      "eks:CreateAddon",
      "eks:DescribeAddon",
      "eks:DeleteAddon",
    ]
    resources = [
      local.hotaru_cluster_arn,
      "${local.eks_arn_prefix}:addon/${var.eks_cluster_name}/*",
      "${local.eks_arn_prefix}:podidentityassociation/${var.eks_cluster_name}/*",
    ]
  }

  statement {
    sid       = "CreateHotaruAccessEntries"
    effect    = "Allow"
    actions   = ["eks:CreateAccessEntry"]
    resources = [local.hotaru_cluster_arn]

    condition {
      test     = "ArnEquals"
      variable = "eks:principalArn"
      values = [
        data.aws_iam_role.cluster_admin.arn,
        aws_iam_role.hotaru_deploy_ci.arn,
        aws_iam_role.hotaru_cluster_ci.arn,
      ]
    }
  }

  statement {
    sid    = "ManageHotaruAccessEntries"
    effect = "Allow"
    actions = [
      "eks:DescribeAccessEntry",
      "eks:DeleteAccessEntry",
      "eks:AssociateAccessPolicy",
      "eks:DisassociateAccessPolicy",
      "eks:ListAssociatedAccessPolicies",
    ]
    resources = ["${local.eks_arn_prefix}:access-entry/${var.eks_cluster_name}/*"]
  }

  statement {
    sid    = "ManageHotaruPodIdentityAssociations"
    effect = "Allow"
    actions = [
      "eks:CreatePodIdentityAssociation",
      "eks:DescribePodIdentityAssociation",
      "eks:DeletePodIdentityAssociation",
    ]
    resources = [
      local.hotaru_cluster_arn,
      "${local.eks_arn_prefix}:podidentityassociation/${var.eks_cluster_name}/*",
    ]
  }

  statement {
    sid     = "TagHotaruEksResources"
    effect  = "Allow"
    actions = ["eks:TagResource"]
    resources = [
      local.hotaru_cluster_arn,
      "${local.eks_arn_prefix}:nodegroup/${var.eks_cluster_name}/*",
      "${local.eks_arn_prefix}:addon/${var.eks_cluster_name}/*",
      "${local.eks_arn_prefix}:access-entry/${var.eks_cluster_name}/*",
      "${local.eks_arn_prefix}:podidentityassociation/${var.eks_cluster_name}/*",
    ]
  }

  statement {
    sid     = "PassHotaruRolesToEks"
    effect  = "Allow"
    actions = ["iam:PassRole"]
    resources = [
      aws_iam_role.eks_cluster.arn,
      aws_iam_role.eks_node.arn,
      aws_iam_role.alb_controller.arn,
      aws_iam_role.cluster_autoscaler.arn,
      aws_iam_role.external_dns.arn,
    ]
  }

  statement {
    sid     = "ReadRolesUsedByCluster"
    effect  = "Allow"
    actions = ["iam:GetRole"]
    resources = [
      aws_iam_role.eks_cluster.arn,
      aws_iam_role.eks_node.arn,
      aws_iam_role.alb_controller.arn,
      aws_iam_role.cluster_autoscaler.arn,
      aws_iam_role.external_dns.arn,
      aws_iam_role.hotaru_deploy_ci.arn,
      aws_iam_role.hotaru_cluster_ci.arn,
      data.aws_iam_role.cluster_admin.arn,
      local.eks_nodegroup_service_role_arn,
    ]
  }

  statement {
    sid     = "ListPoliciesOfEksRoles"
    effect  = "Allow"
    actions = ["iam:ListAttachedRolePolicies"]
    resources = [
      aws_iam_role.eks_cluster.arn,
      aws_iam_role.eks_node.arn,
    ]
  }

  statement {
    sid    = "DescribeNetwork"
    effect = "Allow"
    actions = [
      "ec2:DescribeVpcs",
      "ec2:DescribeVpcAttribute",
      "ec2:DescribeSubnets",
      "ec2:DescribeRouteTables",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "CheckLeftovers"
    effect = "Allow"
    actions = [
      "tag:GetResources",
      "elasticloadbalancing:DescribeLoadBalancers",
      "ec2:DescribeInstances",
    ]
    resources = ["*"]
  }

  statement {
    sid       = "FindHostedZone"
    effect    = "Allow"
    actions   = ["route53:ListHostedZonesByName"]
    resources = ["*"]
  }

  statement {
    sid       = "ListHotaruRecords"
    effect    = "Allow"
    actions   = ["route53:ListResourceRecordSets"]
    resources = [data.aws_route53_zone.main.arn]
  }
}

resource "aws_iam_role_policy" "hotaru_cluster_ci" {
  name   = "cluster-up-down"
  role   = aws_iam_role.hotaru_cluster_ci.id
  policy = data.aws_iam_policy_document.hotaru_cluster_ci.json
}
