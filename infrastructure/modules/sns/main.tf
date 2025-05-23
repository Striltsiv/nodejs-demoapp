# --------------------------------------------------
# SNS Topic for ASG Notifications
# --------------------------------------------------
resource "aws_sns_topic" "asg_notifications" {
  name = "asg-notifications-topic"
}

# --------------------------------------------------
# Email Subscription
# --------------------------------------------------
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.asg_notifications.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

# --------------------------------------------------
# Auto Scaling Notifications
# --------------------------------------------------
resource "aws_autoscaling_notification" "asg_notification" {
  group_names = [var.asg_name]
  topic_arn   = aws_sns_topic.asg_notifications.arn

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
  ]
}

terraform {
  backend "local" {}
}
