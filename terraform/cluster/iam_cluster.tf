data "aws_iam_policy_document" "eks_cluster_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_cluster" {
  name               = "hotaru-eks-cluster"
  description        = "Assumed by Amazon EKS to manage the hotaru cluster"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_trust.json
}
