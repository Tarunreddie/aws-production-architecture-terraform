variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "aws-autohealing-platform"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "alarm_email" {
  type        = string
  description = "Email to receive SNS alarm notifications"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "min_size" {
  type    = number
  default = 1
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 4
}
