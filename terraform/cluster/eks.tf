resource "aws_eks_cluster" "hotaru" {
  name                          = var.cluster_name
  version                       = var.kubernetes_version
  role_arn                      = aws_iam_role.eks_cluster.arn
  bootstrap_self_managed_addons = false

  vpc_config {
    subnet_ids              = values(aws_subnet.public)[*].id
    endpoint_public_access  = true
    endpoint_private_access = true
    public_access_cidrs     = ["0.0.0.0/0"]
  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = false
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster]
}
