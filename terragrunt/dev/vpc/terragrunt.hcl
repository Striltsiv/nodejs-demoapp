# Specify the source Terraform module for this component
terraform {
  # Locate the root infrastructure folder and use the VPC module inside the modules directory
  source = "${find_in_parent_folders("infrastructure")}/modules/vpc"
}

# Provide input variables required by the VPC Terraform module
inputs = {
  # The CIDR block for the entire VPC
  vpc_cidr = "10.0.0.0/16"

  # List of CIDR blocks for the public subnets
  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

# Include the common Terragrunt configuration from a parent folder (e.g., provider, remote state)
include {
  path = find_in_parent_folders()
}
