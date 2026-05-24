module "vpc" {
  source = "./modules/vpc"

  vpc_cidr   = var.vpc_cidr
  subnet_cidr = "10.0.1.0/24"
  environment = terraform.workspace
}

module "security_group" {
  source = "./modules/security-group"

  vpc_id     = module.vpc.vpc_id
  environment = terraform.workspace
}

module "ec2" {
  source = "./modules/ec2"

  instance_type    = var.instance_type
  subnet_id        = module.vpc.subnet_id
  security_group_id = module.security_group.sg_id
  environment      = terraform.workspace
}

module "s3" {
  source = "./modules/s3"

  environment = terraform.workspace
}