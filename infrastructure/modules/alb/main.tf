# --------------------------------------------------
# Application Load Balancer (ALB)
# --------------------------------------------------
resource "aws_lb" "app" {
  # Name of the ALB
  name = "app-alb"

  # ALB is internet-facing (public)
  internal = false

  # Type of load balancer
  load_balancer_type = "application"

  # Security group assigned to the ALB
  security_groups = [var.lb_sg_id]

  # Subnets where ALB will be deployed
  subnets = var.subnets

  # Tags for resource identification
  tags = {
    Name = "app-alb"
  }
}

# --------------------------------------------------
# Target Group for ALB
# --------------------------------------------------
resource "aws_lb_target_group" "app" {
  # Name of the target group
  name = "app-target-group"

  # Port and protocol the target group listens on
  port     = 80
  protocol = "HTTP"

  # VPC in which the target group operates
  vpc_id = var.vpc_id

  # Health check configuration
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# --------------------------------------------------
# ALB Listener
# --------------------------------------------------
resource "aws_lb_listener" "http" {
  # ARN of the load balancer
  load_balancer_arn = aws_lb.app.arn

  # Listener port and protocol
  port     = 80
  protocol = "HTTP"

  # Default action: forward requests to the target group
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
