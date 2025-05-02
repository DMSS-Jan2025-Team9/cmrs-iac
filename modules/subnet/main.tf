resource "aws_subnet" "this" {
  for_each   = var.subnet_parameters
  vpc_id   = lookup(var.vpc_ids_map, each.value.vpc_name)   # Look up VPC ID using VPC name
  cidr_block = each.value.cidr_block
  availability_zone = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  tags = merge(each.value.tags, {
    Name : each.key
  })
}