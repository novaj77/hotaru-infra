data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {
    sid    = "DescribeForAutoDiscovery"
    effect = "Allow"
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeScalingActivities",
      "ec2:DescribeImages",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplateVersions",
      "ec2:GetInstanceTypesFromInstanceRequirements",
    ]
    resources = ["*"]
  }

  statement {
    sid       = "DescribeHotaruNodegroups"
    effect    = "Allow"
    actions   = ["eks:DescribeNodegroup"]
    resources = ["arn:aws:eks:${var.region}:${data.aws_caller_identity.current.account_id}:nodegroup/${var.eks_cluster_name}/*/*"]
  }

  statement {
    sid    = "ScaleHotaruNodegroups"
    effect = "Allow"
    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/k8s.io/cluster-autoscaler/${var.eks_cluster_name}"
      values   = ["owned"]
    }
  }
}

resource "aws_iam_policy" "cluster_autoscaler" {
  name        = "hotaru-cluster-autoscaler"
  description = "Allows Cluster Autoscaler to discover and scale the node groups of the hotaru cluster"
  policy      = data.aws_iam_policy_document.cluster_autoscaler.json
}

resource "aws_iam_role" "cluster_autoscaler" {
  name               = "hotaru-cluster-autoscaler"
  description        = "Assumed through EKS Pod Identity by Cluster Autoscaler"
  assume_role_policy = data.aws_iam_policy_document.pod_identity_trust.json
}
