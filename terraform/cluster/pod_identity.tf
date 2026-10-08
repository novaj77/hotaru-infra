data "aws_iam_role" "alb_controller" {
  name = "hotaru-alb-controller"
}

resource "aws_eks_pod_identity_association" "alb_controller" {
  cluster_name    = aws_eks_cluster.hotaru.name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = data.aws_iam_role.alb_controller.arn
}

data "aws_iam_role" "cluster_autoscaler" {
  name = "hotaru-cluster-autoscaler"
}

resource "aws_eks_pod_identity_association" "cluster_autoscaler" {
  cluster_name    = aws_eks_cluster.hotaru.name
  namespace       = "kube-system"
  service_account = "cluster-autoscaler"
  role_arn        = data.aws_iam_role.cluster_autoscaler.arn
}

data "aws_iam_role" "external_dns" {
  name = "hotaru-external-dns"
}

resource "aws_eks_pod_identity_association" "external_dns" {
  cluster_name    = aws_eks_cluster.hotaru.name
  namespace       = "kube-system"
  service_account = "external-dns"
  role_arn        = data.aws_iam_role.external_dns.arn
}
