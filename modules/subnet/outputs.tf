output "subnet_ids_map" {
  description = "Map of subnet names to subnet IDs"
  value       = { for s in aws_subnet.this : s.tags.Name => s.id }
}