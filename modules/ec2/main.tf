resource "aws_instance" "this" {
  for_each            = { for instance in var.ec2_instances : instance.instance_name => instance }
  ami                 = each.value.ami_id
  instance_type       = each.value.instance_type
  key_name            = each.value.key_name
  subnet_id           = var.subnet_ids_map[each.value.subnet_name]
  security_groups      = [for sgrp in each.value.security_groups : var.security_group_ids_map[sgrp]] 
  associate_public_ip_address = true

  tags = {
    Name = each.value.instance_name
  }
}

# Attach EBS volume to each EC2 instance
resource "aws_ebs_volume" "this" {
  for_each            = { for instance in var.ec2_instances : instance.instance_name => instance }
  availability_zone   = each.value.availability_zone
  size                = 8  # 8 GiB
  type                = "gp2"  # General Purpose SSD (you can change the type if needed)
  tags = {
    Name = "Volume-${each.value.instance_name}"
  }
}