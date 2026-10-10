data "aws_iam_role" "eks_node" {
  name = "hotaru-eks-node"
}

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

resource "aws_iam_role_policy_attachment" "eks_node" {
  for_each = {
    worker   = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    cni      = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    ecr_pull = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
  }

  role       = aws_iam_role.eks_node.name
  policy_arn = each.value
}
