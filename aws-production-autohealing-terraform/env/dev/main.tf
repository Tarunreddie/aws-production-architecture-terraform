locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "vpc" {
  source       = "../../modules/vpc"
  project_name = var.project_name
  environment  = var.environment
  common_tags  = local.common_tags

  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  azs                  = ["us-east-1a", "us-east-1b"]
}

module "security" {
  source       = "../../modules/security"
  project_name = var.project_name
  environment  = var.environment
  common_tags  = local.common_tags

  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source       = "../../modules/alb"
  project_name = var.project_name
  environment  = var.environment
  common_tags  = local.common_tags

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
}

module "asg" {
  source       = "../../modules/asg"
  project_name = var.project_name
  environment  = var.environment
  common_tags  = local.common_tags

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  ec2_sg_id          = module.security.ec2_sg_id
  target_group_arn   = module.alb.target_group_arn

  instance_type    = var.instance_type
  min_size         = var.min_size
  desired_capacity = var.desired_capacity
  max_size         = var.max_size
}

module "monitoring" {
  source       = "../../modules/monitoring"
  project_name = var.project_name
  environment  = var.environment
  common_tags  = local.common_tags

  autoscaling_group_name = module.asg.asg_name
  alarm_email            = var.alarm_email
}
