# AWS Region (can also be used for setting up the log stream)
variable "aws_region" {
  description = "The AWS region to deploy the ECS service"
  type        = string
}

variable "vpc_parameters" {
  description = "VPC parameters"
  type = map(object({
    cidr_block           = string
    enable_dns_support   = optional(bool, true)
    enable_dns_hostnames = optional(bool, true)
    tags                 = optional(map(string), {})
  }))
  default = {}
}

variable "subnet_parameters" {
  description = "Subnet parameters"
  type = map(object({
    cidr_block = string
    vpc_name   = string
    availability_zone = string
    map_public_ip_on_launch = bool
    tags       = optional(map(string), {})
  }))
  default = {}
}

variable "igw_parameters" {
  description = "IGW parameters"
  type = map(object({
    vpc_name = string
    tags     = optional(map(string), {})
  }))
  default = {}
}


variable "rt_parameters" {
  description = "RT parameters"
  type = map(object({
    vpc_name = string
    tags     = optional(map(string), {})
    routes = optional(list(object({
      cidr_block = string
      use_igw    = optional(bool, true)
      gateway_name = string
    })), [])
  }))
  default = {}
}
variable "rt_association_parameters" {
  description = "RT association parameters"
  type = map(object({
    subnet_name = string
    rt_name     = string
  }))
  default = {}
}

variable "security_group_parameters" {
  description = "Security group parameters"
  type = map(object({
    name                   = string
    description            = string
    revoke_rules_on_delete = string
    vpc_name               = string  # Ensure vpc_name exists
    tags                   = optional(map(string), {})
    ingress = optional(list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      self        = bool
      cidr_blocks = list(string)
      description = string
    })), [])
    egress = optional(list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      description = string
    })), [])
  }))
  default = {}
}

variable "repositories" {
  description = "A map of repositories for the dev environment"
  type = map(object({
    repository_name      = string
    image_tag_mutability = string
    tags                 = optional(map(string), {})
    lifecycle_policy     = optional(string, "")
  }))
}

variable "ecs_cluster" {
  description = "The map of the ECS cluster"
  type        = object({
    cluster_name                     = string
    cluster_service_connect_defaults = string
    vpc_name                         = string
  })
}

variable "execution_role_name" {
  description = "The name of the ECS task execution role"
  type        = string
}

variable "service_role_name" {
  description = "The name of the ECS service role"
  type        = string
}

variable "log_retention_in_days" {
  description = "The retention in days for log groups"
  type        = number
}

variable "load_balancer_config" {
  description = "Application load balancer configuration for ECS services"
  type = object({
    alb_name            = string
    subnets             = list(string)
    security_groups     = list(string)
    vpc_name            = string
    acm_certificate_arn = optional(string)
  })
}

variable "microservices" {
  description = "Map of ECS microservices"
  type = map(object({
    container_port       : number            # Port the container listens to
    cpu                  : number            # CPU units for the container
    memory               : number            # Memory in MB for the container
    desired_count        : number            # Desired number of container instances
    repository_name      : string            # ECR repository name for each microservice
    image_version        : string            # Version of the image for each microservice
    subnets_names        : list(string)      # List of subnet names for the microservice
    security_group_names : list(string)      # List of security group names for the microservice
    tags                 = optional(map(string), {})
    autoscaling = object({                   # Autoscaling configuration for the microservice
      min_capacity      = number
      max_capacity      = number
      cpu_target_value  = number
    })
    healthCheck = object({                   # HealthCheck configuration for the microservice
      interval      = number
      timeout       = number
      retries       = number
      startPeriod   = number
    })
    enable_service_connect    = bool
    service_connect_namespace = optional(string)
    task_definition_arn       = optional(string)
  }))
}

variable "rds_config" {
  description = "RDS configuration"
  type = object({
    db_name               = string
    db_identifier         = string
    db_instance_class     = string
    db_engine             = string
    db_engine_version     = string
    db_username           = string
    db_password           = string
    db_port               = number
    db_allocated_storage  = number
    db_subnet_group_name  = string
    multi_az              = bool
    security_group_name   = string
    subnets_names            = list(string) 
  })
}

variable "rabbitmq_config" {
  type = object({
    broker_name        = string
    engine_version     = string
    host_instance_type = string
    deployment_mode    = string
    subnets         = list(string)
    publicly_accessible = bool
    security_groups = list(string)
    username           = string
    password           = string
    configuration_data = string
    maintenance_window = object({
      day     = string
      time    = string
      timezone = string
    })
  })
  sensitive = true
}

variable "ec2_instances" {
  description = "List of EC2 instances with configurations"
  type = list(object({
    instance_name     = string
    ami_id            = string
    instance_type     = string
    key_name          = string
    subnet_name       = string
    security_groups   = list(string)
    availability_zone = string
  }))
}