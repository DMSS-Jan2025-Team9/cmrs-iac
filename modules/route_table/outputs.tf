output "route_table_ids" {
  description = "A map of route table names to route table IDs"
  value       = { for k, v in aws_route_table.this : k => v.id }
}

output "route_table_associations" {
  description = "A map of route table names to subnet associations"
  value       = { for k, v in aws_route_table_association.this : k => v.subnet_id }
}

output "route_table_tags" {
  description = "A map of route table names to their tags"
  value       = { for k, v in aws_route_table.this : k => v.tags }
}