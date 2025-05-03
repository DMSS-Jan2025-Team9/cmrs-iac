resource "aws_route_table" "this" {
  for_each = var.rt_parameters
  vpc_id   = lookup(var.vpc_ids_map, each.value.vpc_name)   # Look up VPC ID using VPC name
  tags = merge(each.value.tags, {
    Name : each.key
  })

  dynamic "route" {
    for_each = each.value.routes
    content {
      cidr_block = route.value.cidr_block
      gateway_id = route.value.use_igw ? lookup(var.igw_ids_map, route.value.gateway_name, route.value.gateway_name) : route.value.gateway_name
    }
  }
}

resource "aws_route_table_association" "this" {
  for_each       = var.rt_association_parameters
  subnet_id      = lookup(var.subnet_ids_map, each.value.subnet_name)   # Looking up by subnet_name
  route_table_id = aws_route_table.this[each.value.rt_name].id
}
