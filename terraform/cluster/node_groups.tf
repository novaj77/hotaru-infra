resource "aws_eks_node_group" "system" {
  cluster_name    = aws_eks_cluster.hotaru.name
  node_group_name = "system"
  node_role_arn   = aws_iam_role.eks_node.arn
  subnet_ids      = data.aws_subnets.public.ids
  ami_type        = "AL2023_x86_64_STANDARD"
  capacity_type   = "ON_DEMAND"
  instance_types  = ["t3.medium"]

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 1
  }

  labels = {
    role = "system"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_node,
    aws_eks_addon.vpc_cni,
    aws_eks_addon.kube_proxy,
  ]
}

resource "aws_eks_node_group" "spot" {
  cluster_name    = aws_eks_cluster.hotaru.name
  node_group_name = "spot"
  node_role_arn   = aws_iam_role.eks_node.arn
  subnet_ids      = data.aws_subnets.public.ids
  ami_type        = "AL2023_x86_64_STANDARD"
  capacity_type   = "SPOT"
  instance_types  = ["t3.medium", "t3a.medium"]

  scaling_config {
    desired_size = 0
    min_size     = 0
    max_size     = 2
  }

  labels = {
    role = "spot"
  }

  taint {
    key    = "spot"
    value  = "true"
    effect = "NO_SCHEDULE"
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_node,
    aws_eks_addon.vpc_cni,
    aws_eks_addon.kube_proxy,
  ]
}
