resource "aws_internet_gateway" "this" {
  for_each = var.igw_parameters
  vpc_id   = lookup(var.vpc_ids_map, each.value.vpc_name)   # Look up VPC ID using VPC name
  tags = merge(each.value.tags, {
    Name : each.key
  })
}