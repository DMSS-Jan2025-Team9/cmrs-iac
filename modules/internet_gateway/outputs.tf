output "igw_ids_map" {
  value = { for igw in aws_internet_gateway.this : igw.tags.Name => igw.id }
}