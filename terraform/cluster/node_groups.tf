resource "aws_eks_node_group" "system" {
  cluster_name    = aws_eks_cluster.hotaru.name
  node_group_name = "system"
  node_role_arn   = aws_iam_role.eks_node.arn
  subnet_ids      = values(aws_subnet.public)[*].id

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_node,
    aws_eks_addon.vpc_cni,
    aws_eks_addon.kube_proxy,
  ]
}
