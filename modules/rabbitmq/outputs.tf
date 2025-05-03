output "rabbitmq_broker_id" {
  description = "The ID of the RabbitMQ broker"
  value       = aws_mq_broker.rabbitmq_broker.id
}

output "rabbitmq_broker_config_id" {
  description = "The ID of the RabbitMQ broker configuration"
  value       = aws_mq_configuration.rabbitmq_broker_config.id
}

output "rabbitmq_broker_config_revision" {
  description = "The revision number of the RabbitMQ broker configuration"
  value       = aws_mq_configuration.rabbitmq_broker_config.latest_revision
}
