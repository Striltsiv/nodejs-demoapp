# --------------------------------------------------
# Create an SNS topic to send Auto Scaling Group (ASG) notifications
# --------------------------------------------------
resource "aws_sns_topic" "asg_notifications" {
  name = "asg-notifications-topic"                  # Name of the SNS topic for ASG notifications
}

# --------------------------------------------------
# Subscribe an email endpoint to the SNS topic
# --------------------------------------------------
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.asg_notifications.arn  # ARN of the SNS topic to subscribe to
  protocol  = "email"                               # Use email protocol for notifications
  endpoint  = var.notification_email                # Email address to receive notifications (from variable)
}

# --------------------------------------------------
# Configure the Auto Scaling Group to send notifications to the SNS topic
# --------------------------------------------------
resource "aws_autoscaling_notification" "asg_notification" {
  group_names   = [aws_autoscaling_group.app.name]   # ASG to monitor for lifecycle events
  topic_arn     = aws_sns_topic.asg_notifications.arn # SNS topic to publish notifications to

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",               # Notify when an instance launches
    "autoscaling:EC2_INSTANCE_TERMINATE",            # Notify when an instance terminates
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",         # Notify on launch failure
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"       # Notify on termination failure
  ]
}
