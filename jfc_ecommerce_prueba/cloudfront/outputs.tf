output "s3_bucket_id" {
  description = "ID del bucket de S3"
  value       = aws_s3_bucket.cloudfront_s3_bucket.id
}

output "cloudfront_domain_name" {
  description = "URL de la distribución de CloudFront"
  value       = aws_cloudfront_distribution.cloudfront_distribution.domain_name
}