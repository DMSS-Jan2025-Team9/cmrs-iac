resource "aws_db_subnet_group" "this" {
  name       = var.db_subnet_group_name
  subnet_ids = var.subnet_ids
  tags = {
    Name = var.db_subnet_group_name
  }
}

resource "aws_db_instance" "cmrsRDS" {
  db_name            = var.db_name
  identifier         = var.db_identifier
  instance_class     = var.db_instance_class
  engine             = var.db_engine
  engine_version     = var.db_engine_version
  username           = var.db_username
  password           = var.db_password
  port               = var.db_port
  allocated_storage  = var.db_allocated_storage
  skip_final_snapshot = true
  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name  = aws_db_subnet_group.this.name
  multi_az            = var.multi_az

  tags = {
    Name = "cmrs-db-instance"
  }
}