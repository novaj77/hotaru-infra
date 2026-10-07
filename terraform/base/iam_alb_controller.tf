resource "aws_iam_policy" "alb_controller" {
  name        = "hotaru-alb-controller"
  description = "Official IAM policy of AWS Load Balancer Controller v3.5.0"
  policy      = file("${path.module}/policies/aws-load-balancer-controller-v3.5.0.json")
}
