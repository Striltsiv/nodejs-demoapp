variable "name" {
  type        = string
  description = "Name of the ALB"
}

variable "subnets" {
  type        = list(string)
  description = "Public subnets for the ALB"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "lb_sg_id" {
  type        = string
  description = "Security group for the ALB"
}
