# Specify the source Terraform module for this component
terraform {
  # Locate the root infrastructure folder and use the SNS module inside the modules directory
  source = "${find_in_parent_folders("infrastructure")}/modules/sns"
}

# Declare dependency on the EC2 (Auto Scaling Group) module
dependency "asg" {
  # Path to the EC2 module configuration
  config_path = "../ec2"

  # Mock outputs used during `terragrunt plan` when the actual dependency is not yet applied
  mock_outputs = {
    asg_name = "mock-asg"
  }
}

# Provide input variables required by the SNS Terraform module
inputs = {
  # Pass the Auto Scaling Group name from the EC2 dependency
  asg_name = dependency.asg.outputs.asg_name
}

# Include the common Terragrunt configuration from a parent folder (e.g., provider, remote state)
include {
  path = find_in_parent_folders()
}
