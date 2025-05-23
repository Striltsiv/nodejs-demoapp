variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ec2_sg_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "target_group_arn" {
  type = string
}

variable "desired_capacity" {
  type    = number
  default = 1
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 3
}

variable "user_data_path" {
  description = "Path to the user data script"
  type        = string
}

