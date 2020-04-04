variable "aws_region" {
  description = "The AWS region to create things in"
}

variable "app_name" {
  description = "Name of application"
  default     = "feed-the-cat"
}

variable "email_sender" {
  description = "SES verified email address to send alarms"
}

variable "email_recipient" {
  description = "Recipient Email address to receive alerts"
}
