variable "region" {
  default = "eu-north-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "instance_type" {
  default = "t3.micro"
}

variable "ami_id" {
  default = "ami-0c1ac8a41498c1a9c"
}

variable "notification_email" {
  description = "Email for Auto Scaling notifications"
  type        = string
}
