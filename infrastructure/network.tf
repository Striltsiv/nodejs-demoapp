# --------------------------------------------------
# Create a Virtual Private Cloud (VPC)
# --------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr                         # The CIDR block for the VPC (e.g., 10.0.0.0/16), passed via variable
}

# --------------------------------------------------
# Create an Internet Gateway and attach it to the VPC
# --------------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id                          # Attach the IGW to the VPC
}

# --------------------------------------------------
# Create multiple public subnets
# --------------------------------------------------
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)          # Create one subnet per CIDR block in the variable list

  vpc_id                  = aws_vpc.main.id        # Associate the subnet with the VPC
  cidr_block              = var.public_subnet_cidrs[count.index]  # Assign CIDR block by index
  map_public_ip_on_launch = true                    # Automatically assign public IP on instance launch
  availability_zone       = data.aws_availability_zones.available.names[count.index]  # Distribute across AZs
}

# --------------------------------------------------
# Data source to fetch available AWS Availability Zones in the selected region
# --------------------------------------------------
data "aws_availability_zones" "available" {}

# --------------------------------------------------
# Create a route table for the public subnets
# --------------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id                          # Associate route table with the VPC

  route {
    cidr_block = "0.0.0.0/0"                        # Route all outbound IPv4 traffic
    gateway_id = aws_internet_gateway.igw.id       # Send traffic via the Internet Gateway
  }
}

# --------------------------------------------------
# Associate the public route table with each public subnet
# --------------------------------------------------
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)        # One association per public subnet
  subnet_id      = aws_subnet.public[count.index].id  # Subnet to associate
  route_table_id = aws_route_table.public.id        # Route table to associate with the subnet
}
