provider "aws" {
  region = "us-east-1"
}


resource "aws_s3_bucket" "cloudfront_s3_bucket" {
  bucket = "${var.project_name}-s3"

  
  tags = {
    Name = "${var.project_name}-s3"
  }
}


resource "aws_s3_bucket_policy" "cloudfront_s3_policy" {
  bucket = aws_s3_bucket.cloudfront_s3_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = "s3:GetObject"
      Effect   = "Allow"
      Resource = "${aws_s3_bucket.cloudfront_s3_bucket.arn}/*"
      Principal = {
        AWS = aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
      }
    }]
  })
}


resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  origin {
    domain_name = aws_s3_bucket.cloudfront_s3_bucket.bucket_domain_name
    origin_id   = "S3-${aws_s3_bucket.cloudfront_s3_bucket.id}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.cloudfront_s3_bucket.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "${var.project_name}-cloudfront"
  }
}


resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "OAI for S3 bucket"
}

