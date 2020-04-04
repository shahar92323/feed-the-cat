variable "aws_region" {
  description = "The AWS region to create things in"
  default     = "us-east-1"
}

variable "app_name" {
  description = "Name of application"
  default     = "feed-the-cat"
}

variable "email_sender" {
  description = "SES verified email address to send alarms"
  default     = "no-reply@theculturetrip.com"
}

variable "email_recipient" {
  description = "Recipient Email address to receive alerts"
  default     = "shahar.ron@theculturetrip.com"
}
