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

}
