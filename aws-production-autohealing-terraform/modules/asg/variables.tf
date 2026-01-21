variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ec2_sg_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "min_size" {
  type = number
}

variable "desired_capacity" {
  type = number
}

variable "max_size" {
  type = number
}
