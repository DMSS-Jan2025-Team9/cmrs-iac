output "instance_ids" {
  description = "List of EC2 instance IDs"
  value       = [for instance in aws_instance.this : instance.id]
}

output "public_ips" {
  description = "List of EC2 instance public IPs"
  value       = [for instance in aws_instance.this : instance.public_ip]
}