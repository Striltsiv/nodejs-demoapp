# Specify the source Terraform module for this component
terraform {
  # Locate the root infrastructure folder and use the Security Group (sg) module
  source = "${find_in_parent_folders("infrastructure")}/modules/sg"
}

# Declare dependency on the VPC module to access its outputs
dependency "vpc" {
  # Path to the VPC module configuration
  config_path = "../../vpc"
}

# Provide input variables required by the SG Terraform module
inputs = {
  # Pass the VPC ID obtained from the VPC dependency
  vpc_id = dependency.vpc.outputs.vpc_id
}
