variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "autoscaling_group_name" {
  type = string
}

variable "alarm_email" {
  type = string
}
