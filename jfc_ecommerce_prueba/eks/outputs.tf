output "eks_cluster_name" {
  description = "Nombre del clúster de EKS"
  value       = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_endpoint" {
  description = "Endpoint del clúster de EKS"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_version" {
  description = "Versión del clúster de EKS"
  value       = aws_eks_cluster.eks_cluster.version
}


