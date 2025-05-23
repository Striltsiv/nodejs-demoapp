# --------------------------------------------------
# Launch Template for EC2 Instances
# --------------------------------------------------
resource "aws_launch_template" "app" {
  # Prefix for the launch template name
  name_prefix = "app-template-"

  # AMI ID to use for EC2 instances
  image_id = var.ami_id

  # EC2 instance type
  instance_type = var.instance_type

  # User data script to initialize the instance (base64-encoded)
  user_data = base64encode(file(var.user_data_path))

  # Network settings
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.ec2_sg_id]
  }

  # Ensure new template is created before destroying the old one
  lifecycle {
    create_before_destroy = true
  }
}

# --------------------------------------------------
# Auto Scaling Group for EC2 Instances
# --------------------------------------------------
resource "aws_autoscaling_group" "app_asg" {
  # Desired, minimum, and maximum capacity settings
  desired_capacity = var.desired_capacity
  max_size         = var.max_size
  min_size         = var.min_size

  # Subnets in which to launch EC2 instances
  vpc_zone_identifier = var.subnets

  # Attach to the ALB target group for load balancing
  target_group_arns = [var.target_group_arn]

  # Reference to the launch template created above
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  # Tag to help identify EC2 instances in the group
  tag {
    key                 = "Name"
    value               = "nodejs-instance"
    propagate_at_launch = true
  }
}

# --------------------------------------------------
# Terraform Backend Configuration
# --------------------------------------------------
terraform {
  backend "local" {}
}
