resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.hotaru.name
  addon_name   = "vpc-cni"

  configuration_values = jsonencode({
    env = {
      ENABLE_PREFIX_DELEGATION = "true"
    }
  })
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.hotaru.name
  addon_name   = "kube-proxy"
}
