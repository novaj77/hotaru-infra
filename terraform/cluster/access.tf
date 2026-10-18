data "aws_iam_role" "cluster_admin" {
  name = var.cluster_admin_role_name
}

resource "aws_eks_access_entry" "cluster_admin" {
  cluster_name  = aws_eks_cluster.hotaru.name
  principal_arn = data.aws_iam_role.cluster_admin.arn
}

resource "aws_eks_access_policy_association" "cluster_admin" {
  cluster_name  = aws_eks_cluster.hotaru.name
  principal_arn = aws_eks_access_entry.cluster_admin.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}

data "aws_iam_role" "hotaru_deploy_ci" {
  name = "hotaru-deploy-github-actions"
}

resource "aws_eks_access_entry" "hotaru_deploy_ci" {
  cluster_name  = aws_eks_cluster.hotaru.name
  principal_arn = data.aws_iam_role.hotaru_deploy_ci.arn
}

resource "aws_eks_access_policy_association" "hotaru_deploy_ci" {
  cluster_name  = aws_eks_cluster.hotaru.name
  principal_arn = aws_eks_access_entry.hotaru_deploy_ci.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"

  access_scope {
    type       = "namespace"
    namespaces = ["hotaru"]
  }
}

data "aws_iam_role" "hotaru_cluster_ci" {
  name = "hotaru-cluster-github-actions"
}

resource "aws_eks_access_entry" "hotaru_cluster_ci" {
  cluster_name  = aws_eks_cluster.hotaru.name
  principal_arn = data.aws_iam_role.hotaru_cluster_ci.arn
}

resource "aws_eks_access_policy_association" "hotaru_cluster_ci" {
  cluster_name  = aws_eks_cluster.hotaru.name
  principal_arn = aws_eks_access_entry.hotaru_cluster_ci.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}
