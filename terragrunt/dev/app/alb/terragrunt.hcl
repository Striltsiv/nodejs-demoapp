# Specify the source of the Terraform ALB module
terraform {
  # Locate the ALB module in the parent infrastructure folder
  source = "${find_in_parent_folders("infrastructure")}/modules/alb"
}

# Dependency on the VPC module to get VPC ID and subnet IDs
dependency "vpc" {
  config_path = "../../vpc"
}

# Dependency on the Security Group module to get the ALB security group ID
dependency "sg" {
  config_path = "../sg"
}

# Input variables passed to the ALB module
inputs = {
  # VPC ID where the ALB will be deployed
  vpc_id    = dependency.vpc.outputs.vpc_id

  # Public subnets to deploy the ALB across availability zones
  subnets   = dependency.vpc.outputs.public_subnets

  # Security Group ID for the ALB
  lb_sg_id  = dependency.sg.outputs.alb_sg_id

  # Name of the Application Load Balancer
  name      = "demoapp-alb-dev"
}
