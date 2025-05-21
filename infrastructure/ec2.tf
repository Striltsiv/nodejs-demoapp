# --------------------------------------------------
# Launch template for EC2 instances
# --------------------------------------------------
resource "aws_launch_template" "app" {
  name_prefix   = "app-template-"                      # Prefix for the launch template name
  image_id      = var.ami_id                           # AMI ID for the EC2 instance
  instance_type = var.instance_type                    # Instance type (e.g., t2.micro)

  user_data = base64encode(file("${path.module}/../user_data/user_data.sh")) # Bootstrap script to install app

  network_interfaces {
    associate_public_ip_address = true                 # Assign public IP to the instance
    security_groups             = [aws_security_group.ec2_sg.id] # Attach EC2 security group
  }

  lifecycle {
    create_before_destroy = true                       # Create new template before destroying the old one
  }
}

# --------------------------------------------------
# Auto Scaling Group to manage EC2 instances
# --------------------------------------------------
resource "aws_autoscaling_group" "app" {
  desired_capacity    = 1                             # Number of instances to maintain
  max_size            = 3                             # Maximum number of instances
  min_size            = 1                             # Minimum number of instances
  vpc_zone_identifier = aws_subnet.public[*].id      # Use public subnets for instances
  target_group_arns   = [aws_lb_target_group.app.arn]# Attach instances to target group

  launch_template {
    id      = aws_launch_template.app.id              # Reference the launch template
    version = "$Latest"                                # Use the latest version
  }

  tag {
    key                 = "Name"
    value               = "nodejs-instance"           # Name tag for EC2 instances
    propagate_at_launch = true                         # Apply the tag at instance launch
  }
}

# --------------------------------------------------
# Security group for EC2 instances
# --------------------------------------------------
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow HTTP from ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80                              # Allow HTTP traffic from ALB
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]  # Only allow from the load balancer SG
  }

  egress {
    from_port   = 0                                   # Allow all outbound traffic
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --------------------------------------------------
# Application Load Balancer
# --------------------------------------------------
resource "aws_lb" "app" {
  name               = "app-lb"                       # Load balancer name
  internal           = false                           # Public facing
  load_balancer_type = "application"                  # ALB type
  subnets            = aws_subnet.public[*].id        # Place in public subnets
  security_groups    = [aws_security_group.lb_sg.id]  # Use LB security group
}

# --------------------------------------------------
# Target group for the load balancer
# --------------------------------------------------
resource "aws_lb_target_group" "app" {
  name     = "app-target-group"
  port     = 80                                       # Forward traffic to port 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"                          # Health check endpoint
    port                = "80"
    protocol            = "HTTP"
    matcher             = "200"                        # Expect HTTP 200 response
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# --------------------------------------------------
# Listener to forward traffic from ALB to target group
# --------------------------------------------------
resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80                              # Listen on HTTP port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn    # Forward to app target group
  }
}

# --------------------------------------------------
# Security group for the Load Balancer
# --------------------------------------------------
resource "aws_security_group" "lb_sg" {
  name        = "lb_sg"
  description = "Allow HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80                                  # Allow HTTP from anywhere
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0                                   # Allow all outbound traffic
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
