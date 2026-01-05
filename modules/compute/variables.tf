variable "project" { type = string }
variable "env" { type = string }

variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "private_subnet_ids" { type = list(string) }

variable "alb_sg_id" { type = string }
variable "ec2_sg_id" { type = string }

variable "ami_id" { type = string }
variable "instance_type" { type = string }
variable "user_data_path" { type = string }

variable "s3_bucket_name" { type = string }
