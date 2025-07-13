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

output "eks_node_group_name" {
  description = "Nombre del grupo de nodos del EKS"
  value       = aws_eks_node_group.eks_node_group.node_group_name
}
