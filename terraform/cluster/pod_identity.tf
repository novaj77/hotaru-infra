data "aws_iam_role" "alb_controller" {
  name = "hotaru-alb-controller"
}

resource "aws_eks_pod_identity_association" "alb_controller" {
  cluster_name    = aws_eks_cluster.hotaru.name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = data.aws_iam_role.alb_controller.arn
}
