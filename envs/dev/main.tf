module "vpc" {
  source          = "../../modules/vpc"
  vpc_parameters  = var.vpc_parameters
}

module "internet_gateway" {
  source           = "../../modules/internet_gateway"
  vpc_ids_map      = module.vpc.vpc_ids_map  # Pass the vpc_ids_map from the VPC module
  igw_parameters   = var.igw_parameters
}

module "subnet" {
  source             = "../../modules/subnet"
  vpc_ids_map        = module.vpc.vpc_ids_map  # Pass the vpc_ids_map from the VPC module
  subnet_parameters  = var.subnet_parameters
}

module "route_table" {
  source                    = "../../modules/route_table"
  vpc_ids_map               = module.vpc.vpc_ids_map  # Pass the vpc_ids_map from the VPC module
  subnet_ids_map            = module.subnet.subnet_ids_map  # Pass the subnet_ids_map from the subnet module 
  igw_ids_map               = module.internet_gateway.igw_ids_map  # Pass the subnet_ids_map from the internet gateway module 
  rt_parameters             = var.rt_parameters
  rt_association_parameters = var.rt_association_parameters
}

module "security_group" {
  source                    = "../../modules/security_group"
  vpc_ids_map               = module.vpc.vpc_ids_map  # Pass the vpc_ids_map from the VPC module
  security_group_parameters = var.security_group_parameters
}

module "ecr" {
  source      = "../../modules/ecr"
  repositories = var.repositories  # Pass the repositories defined in dev variables
}