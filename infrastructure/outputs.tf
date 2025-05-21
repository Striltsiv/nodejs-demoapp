output "alb_dns_name" {
  value       = aws_lb.app.dns_name
  description = "Application Load Balancer DNS"
}
