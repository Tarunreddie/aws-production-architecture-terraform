data "aws_availability_zones" "available" {}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

module "network" {
  source               = "./modules/network"
  project              = var.project
  env                  = var.env
  vpc_cidr             = var.vpc_cidr
  azs                  = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "security" {
  source          = "./modules/security"
  project         = var.project
  env             = var.env
  vpc_id          = module.network.vpc_id
  alb_ingress_cidr = "0.0.0.0/0"
}

module "storage" {
  source  = "./modules/storage"
  project = var.project
  env     = var.env
}

module "compute" {
  source                = "./modules/compute"
  project               = var.project
  env                   = var.env
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  private_subnet_ids    = module.network.private_subnet_ids
  alb_sg_id             = module.security.alb_sg_id
  ec2_sg_id             = module.security.ec2_sg_id
  ami_id                = data.aws_ami.al2023.id
  instance_type         = var.instance_type
  user_data_path        = "${path.module}/userdata.sh"
  s3_bucket_name        = module.storage.bucket_name
}
