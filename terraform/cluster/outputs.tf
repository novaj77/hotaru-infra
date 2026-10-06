output "vpc_id" {
  description = "ID of the hotaru VPC"
  value       = aws_vpc.hotaru.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs keyed by availability zone"
  value       = { for az, subnet in aws_subnet.public : az => subnet.id }
}

output "cluster_name" {
  description = "Name of the EKS cluster (for aws eks update-kubeconfig)"
  value       = aws_eks_cluster.hotaru.name
}
