resource "aws_mq_configuration" "rabbitmq_broker_config" {
  description    = "RabbitMQ config"
  name           = var.rabbitmq_config.broker_name
  engine_type    = "RabbitMQ"
  engine_version = var.rabbitmq_config.engine_version
  data           = var.rabbitmq_config.configuration_data
}

resource "aws_mq_broker" "rabbitmq_broker" {
  broker_name         = var.rabbitmq_config.broker_name
  engine_type         = "RabbitMQ"
  engine_version      = var.rabbitmq_config.engine_version
  host_instance_type  = var.rabbitmq_config.host_instance_type
  deployment_mode     = var.rabbitmq_config.deployment_mode
  subnet_ids          = [for subnet_name in var.rabbitmq_config.subnets : var.subnet_ids_map[subnet_name]] 
  publicly_accessible = var.rabbitmq_config.publicly_accessible
  security_groups     = [for sgrp in var.rabbitmq_config.security_groups : var.security_group_ids_map[sgrp]] 
  
  configuration {
    id       = aws_mq_configuration.rabbitmq_broker_config.id
    revision = aws_mq_configuration.rabbitmq_broker_config.latest_revision
  }

  user {
    username = var.rabbitmq_config.username
    password = var.rabbitmq_config.password
  }

  auto_minor_version_upgrade = true

  maintenance_window_start_time {
    day_of_week = var.rabbitmq_config.maintenance_window.day
    time_of_day = var.rabbitmq_config.maintenance_window.time
    time_zone   = var.rabbitmq_config.maintenance_window.timezone
  }

  apply_immediately = true
}
