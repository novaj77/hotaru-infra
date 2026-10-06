resource "aws_eks_cluster" "hotaru" {
  name     = var.cluster_name
  version  = var.kubernetes_version
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = values(aws_subnet.public)[*].id
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster]
}
