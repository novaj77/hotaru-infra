resource "aws_iam_policy" "alb_controller" {
  name        = "hotaru-alb-controller"
  description = "Official IAM policy of AWS Load Balancer Controller v3.5.0"
  policy      = file("${path.module}/policies/aws-load-balancer-controller-v3.5.0.json")
}

resource "aws_iam_role" "alb_controller" {
  name               = "hotaru-alb-controller"
  description        = "Assumed through EKS Pod Identity by AWS Load Balancer Controller"
  assume_role_policy = data.aws_iam_policy_document.pod_identity_trust.json
}

resource "aws_iam_role_policy_attachment" "alb_controller" {
  role       = aws_iam_role.alb_controller.name
  policy_arn = aws_iam_policy.alb_controller.arn
}
