output "aurora_cluster_endpoint" {
  description = "Endpoint del clúster de Aurora"
  value       = aws_rds_cluster.aurora_cluster.endpoint
}

output "aurora_reader_endpoint" {
  description = "Endpoint del lector Aurora"
  value       = aws_rds_cluster.aurora_cluster.reader_endpoint
}