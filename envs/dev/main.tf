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
module "ecs_cluster" {
  source      = "../../modules/ecs_cluster"
  cluster_name = var.ecs_cluster.cluster_name
  vpc_name = var.ecs_cluster.vpc_name
  cluster_service_connect_defaults = var.ecs_cluster.cluster_service_connect_defaults
  vpc_ids_map               = module.vpc.vpc_ids_map  # Pass the vpc_ids_map from the VPC module
}

module "iam_role" {
  source = "../../modules/iam_role"

  execution_role_name = var.execution_role_name
  service_role_name   = var.service_role_name
}

module "log_groups" {
  source = "../../modules/log_group"

  for_each = var.microservices

  name              = "/ecs/${each.key}"
  retention_in_days = var.log_retention_in_days
  tags = each.value.tags
}

module "load_balancer" {
  source = "../../modules/load_balancer"

  load_balancer_config   = var.load_balancer_config
  
  vpc_ids_map            = module.vpc.vpc_ids_map
  subnet_ids_map         = module.subnet.subnet_ids_map
  security_group_ids_map = module.security_group.security_group_ids_map

  ecs_services = [
    for name, svc in var.microservices : {
      name        = name
      port        = svc.container_port
      path_prefix = "/${name}/*"
    }
  ]
}

module "microservices" {
  source = "../../modules/ecs_microservice"

  for_each = var.microservices

  service_name       = each.key
  container_image    = "${module.ecr.repository_uris[each.value.repository_name]}:${each.value.image_version}"  # Corrected dynamic assignment for image version
  container_port     = each.value.container_port
  cpu                = each.value.cpu
  memory             = each.value.memory
  desired_count      = each.value.desired_count

  subnets            = [for subnet_name in each.value.subnets_names : module.subnet.subnet_ids_map[subnet_name]] 
  security_group_ids  = [for sg_name in each.value.security_group_names : module.security_group.security_group_ids_map[sg_name]] 
  execution_role_arn = module.iam_role.ecs_task_execution_role_arn
  ecs_cluster_id     = module.ecs_cluster.ecs_cluster_id
  log_group_name     = module.log_groups[each.key].log_group_name
  aws_region         = var.aws_region

  healthCheck               = each.value.healthCheck
  enable_service_connect    = each.value.enable_service_connect
  service_connect_namespace = each.value.service_connect_namespace
  target_group_arn          = module.load_balancer.target_group_arns[each.key]
}

module "ecs_autoscaling" {
  source = "../../modules/ecs_autoscaling"

  for_each = var.microservices

  ecs_cluster_name   = module.ecs_cluster.ecs_cluster_name
  service_name     = each.key

  min_capacity     = each.value.autoscaling.min_capacity
  max_capacity     = each.value.autoscaling.max_capacity
  cpu_target_value = each.value.autoscaling.cpu_target_value
}

module "rds" {
  source = "../../modules/rds"

  db_name               = var.rds_config.db_name
  db_identifier         = var.rds_config.db_identifier
  db_instance_class     = var.rds_config.db_instance_class
  db_engine             = var.rds_config.db_engine
  db_engine_version     = var.rds_config.db_engine_version
  db_username           = var.rds_config.db_username
  db_password           = var.rds_config.db_password
  db_port               = var.rds_config.db_port
  db_allocated_storage  = var.rds_config.db_allocated_storage
  security_group_id     = module.security_group.security_group_ids_map[var.rds_config.security_group_name] 
  db_subnet_group_name  = var.rds_config.db_subnet_group_name
  multi_az              = var.rds_config.multi_az
  subnet_ids            = [for subnet_name in var.rds_config.subnets_names : module.subnet.subnet_ids_map[subnet_name]] 
}

module "rabbitmq" {
  source = "../../modules/rabbitmq"
  rabbitmq_config = var.rabbitmq_config

  subnet_ids_map = module.subnet.subnet_ids_map
  security_group_ids_map = module.security_group.security_group_ids_map
}

module "ec2_instances" {
  source           = "../../modules/ec2"
  ec2_instances    = var.ec2_instances

  subnet_ids_map = module.subnet.subnet_ids_map
  security_group_ids_map = module.security_group.security_group_ids_map
}
