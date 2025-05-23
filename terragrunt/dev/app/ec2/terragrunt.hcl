# Include root configuration (e.g., provider settings, remote state) from a parent folder
include {
  path = find_in_parent_folders()
}

# Specify the source of the Terraform module for EC2 and Auto Scaling
terraform {
  # Locate the EC2 module in the parent infrastructure folder
  source = "${find_in_parent_folders("infrastructure")}/modules/ec2"
}

# Dependency on the VPC module to retrieve VPC ID and subnet IDs
dependency "vpc" {
  config_path = "../../vpc"
}

# Dependency on the Security Group module to get the EC2 security group ID
dependency "sg" {
  config_path = "../sg"
}

# Dependency on the ALB module to retrieve the target group ARN
dependency "alb" {
  config_path = "../alb"
}

# Input variables for the EC2/ASG module
inputs = {
  # Name prefix for created resources
  name      = "demoapp-dev"

  # Use the VPC ID from the VPC dependency
  vpc_id    = dependency.vpc.outputs.vpc_id

  # EC2 instance Security Group ID from SG module
  ec2_sg_id = dependency.sg.outputs.ec2_sg_id   

  # Minimum number of instances in Auto Scaling Group
  min_size  = 1

  # Maximum number of instances in Auto Scaling Group
  max_size  = 3

  # EC2 instance type
  instance_type = "t3.micro"

  # Amazon Machine Image ID to use
  ami_id    = "ami-0c1ac8a41498c1a9c"

  # Public subnets from VPC module
  subnets           = dependency.vpc.outputs.public_subnets

  # Target group ARN to attach instances for load balancing
  target_group_arn  = dependency.alb.outputs.target_group_arn

  # Path to user data script for EC2 instance initialization
  user_data_path    = "${get_repo_root()}/user_data/user_data.sh"
}
