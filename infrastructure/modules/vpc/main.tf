# --------------------------------------------------
# VPC
# --------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

# --------------------------------------------------
# Internet Gateway
# --------------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# --------------------------------------------------
# Public Subnets
# --------------------------------------------------
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
}

data "aws_availability_zones" "available" {}

# --------------------------------------------------
# Route Table
# --------------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# --------------------------------------------------
# Route Table Association
# --------------------------------------------------
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
terraform {
  backend "local" {}
}
