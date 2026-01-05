variable "aws_region" { type = string  default = "us-east-1" }
variable "project"    { type = string  default = "prod-arch" }
variable "env"        { type = string  default = "dev" }

variable "vpc_cidr" { type = string default = "10.0.0.0/16" }

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "instance_type" { type = string default = "t3.micro" }

# Use latest Amazon Linux 2023 in your region (we’ll fetch it dynamically)
