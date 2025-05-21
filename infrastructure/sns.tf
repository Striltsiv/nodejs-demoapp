# Create an SNS topic to send Auto Scaling Group (ASG) notifications
resource "aws_sns_topic" "asg_notifications" {
  name = "asg-notifications-topic"
}

# Subscribe an email endpoint to the SNS topic
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.asg_notifications.arn  # ARN of the SNS topic
  protocol  = "email"                              # Notification protocol is email
  endpoint  = var.notification_email              # Email address to receive notifications (from variable)
}

# Configure the Auto Scaling Group to send notifications to the SNS topic
resource "aws_autoscaling_notification" "asg_notification" {
  group_names = [aws_autoscaling_group.app.name]  # The name of the ASG to monitor
  topic_arn   = aws_sns_topic.asg_notifications.arn  # SNS topic to send notifications to

  # List of Auto Scaling lifecycle events to be notified about
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",             # Notify when an instance launches
    "autoscaling:EC2_INSTANCE_TERMINATE",          # Notify when an instance terminates
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",       # Notify when launch fails
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"     # Notify when termination fails
  ]
}
