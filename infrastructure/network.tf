# Create a Virtual Private Cloud (VPC)
resource "aws_vpc" "main" {
  # The CIDR block for the VPC (e.g., 10.0.0.0/16), passed via variable
  cidr_block = var.vpc_cidr
}

# Create an Internet Gateway and attach it to the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Create multiple public subnets
resource "aws_subnet" "public" {
  # Create one subnet per CIDR block in the variable list
  count = length(var.public_subnet_cidrs)

  # Associate the subnet with the VPC
  vpc_id = aws_vpc.main.id

  # Assign a unique CIDR block from the list using the current index
  cidr_block = var.public_subnet_cidrs[count.index]

  # Automatically assign a public IP address to instances launched in this subnet
  map_public_ip_on_launch = true

  # Place each subnet in a different availability zone for high availability
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

# Data source to fetch available AWS Availability Zones in the selected region
data "aws_availability_zones" "available" {}

# Create a route table for the public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # Add a route to the internet via the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"            # Route all outbound traffic
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associate the public route table with each public subnet
resource "aws_route_table_association" "public" {
  # Associate the route table with each subnet individually
  count = length(aws_subnet.public)

  # ID of the subnet to associate
  subnet_id = aws_subnet.public[count.index].id

  # ID of the route table to associate with the subnet
  route_table_id = aws_route_table.public.id
}
