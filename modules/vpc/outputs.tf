output "vpc_ids_map" {
  description = "A map of VPC names to VPC IDs"
  value = { for vpc in aws_vpc.this : vpc.tags.Name => vpc.id }
}