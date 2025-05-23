variable "notification_email" {
  description = "Email address for SNS notifications"
  type        = string
}

variable "asg_name" {
  description = "Name of the Auto Scaling Group"
  type        = string
}
