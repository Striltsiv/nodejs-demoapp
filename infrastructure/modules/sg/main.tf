# --------------------------------------------------
# Security Group for EC2 Instances
# --------------------------------------------------
resource "aws_security_group" "ec2_sg" {
  # Name of the security group
  name = "ec2-sg"

  # Description of the security group purpose
  description = "Security group for EC2"

  # The VPC where this security group will be created
  vpc_id = var.vpc_id

  # Inbound rule allowing HTTP traffic on port 80 from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rule allowing all traffic to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --------------------------------------------------
# Security Group for Application Load Balancer (ALB)
# --------------------------------------------------
resource "aws_security_group" "lb_sg" {
  # Name of the ALB security group
  name = "alb-sg"

  # Description of the ALB security group purpose
  description = "Security group for ALB"

  # The VPC where this security group will be created
  vpc_id = var.vpc_id

  # Inbound rule allowing HTTP traffic on port 80 from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rule allowing all traffic to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}
