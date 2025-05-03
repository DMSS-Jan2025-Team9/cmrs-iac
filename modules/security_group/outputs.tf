output "security_group_ids_map" {
  description = "Map of security group tag names to security group IDs"
  value       = { for s in aws_security_group.this : s.tags.Name => s.id }
}