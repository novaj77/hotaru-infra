data "aws_iam_role" "cluster_admin" {
  name = var.cluster_admin_role_name
}

resource "aws_eks_access_entry" "cluster_admin" {
  cluster_name  = aws_eks_cluster.hotaru.name
  principal_arn = data.aws_iam_role.cluster_admin.arn
}
