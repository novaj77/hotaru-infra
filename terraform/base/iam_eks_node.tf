data "aws_iam_policy_document" "eks_node_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_node" {
  name               = "hotaru-eks-node"
  description        = "Assumed by EC2 worker nodes of the hotaru cluster"
  assume_role_policy = data.aws_iam_policy_document.eks_node_trust.json
}
