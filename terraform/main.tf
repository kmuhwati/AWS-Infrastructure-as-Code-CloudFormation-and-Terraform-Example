provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "./network"
  vpc_cidr = var.vpc_cidr
}

module "ec2" {
  source = "./ec2"
  vpc_id = module.network.vpc_id
  public_subnet_id = module.network.public_subnet_id
  instance_type = var.instance_type
  key_name = var.key_name
}

module "rds" {
  source = "./rds"
  vpc_id = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}

module "alb" {
  source = "./alb"
  vpc_id = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  instance_id = module.ec2.instance_id
}