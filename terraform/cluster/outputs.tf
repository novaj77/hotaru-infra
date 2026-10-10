output "cluster_name" {
  description = "Name of the EKS cluster (for aws eks update-kubeconfig)"
  value       = aws_eks_cluster.hotaru.name
}
