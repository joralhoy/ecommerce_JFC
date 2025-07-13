output "alb_dns_name" {
  description = "DNS del ALB"
  value       = aws_lb.alb.dns_name
}
