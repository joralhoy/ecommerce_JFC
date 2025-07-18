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

output "eks_cluster_certificate_authority_data" {
  description = "Datos de la autoridad certificadora del clúster EKS (base64 encoded)"
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

