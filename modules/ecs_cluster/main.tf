resource "aws_service_discovery_private_dns_namespace" "ecs_namespace_appsvc" {
  name        = var.cluster_service_connect_defaults
  description = "Private namespace for ECS"
  vpc         = lookup(var.vpc_ids_map, var.vpc_name)   # Look up VPC ID using VPC name
}

resource "aws_ecs_cluster" "this" {
  name = var.cluster_name

  tags = {
    Name = var.cluster_name
  }

  service_connect_defaults {
    namespace = aws_service_discovery_private_dns_namespace.ecs_namespace_appsvc.arn
  }
}