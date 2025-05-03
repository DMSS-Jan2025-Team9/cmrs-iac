resource "aws_security_group" "this" {
  for_each               = var.security_group_parameters
  name                   = each.value.name
  description            = each.value.description
  vpc_id   = lookup(var.vpc_ids_map, each.value.vpc_name)   # Look up VPC ID using VPC name
  revoke_rules_on_delete = each.value.revoke_rules_on_delete
  tags = merge(each.value.tags, {
    Name : each.key
  })

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      self        = ingress.value.self
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  dynamic "egress" {
    for_each = each.value.egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      description = egress.value.description
    }
  }
}