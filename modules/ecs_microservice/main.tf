resource "aws_ecs_task_definition" "this" {
  family                   = var.service_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = var.service_name
      image     = var.container_image
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
          name          = var.service_name # <-- Required for Service Connect
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.log_group_name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = var.service_name
        }
      }
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:${var.container_port}/${var.service_name}/actuator/health || exit 1"]
        interval    = var.healthCheck.interval
        timeout     = var.healthCheck.timeout
        retries     = var.healthCheck.retries
        startPeriod = var.healthCheck.startPeriod
      }
    }
  ])
}

resource "aws_ecs_service" "this" {
  name            = var.service_name
  cluster         = var.ecs_cluster_id
  task_definition = var.task_definition_arn == null ? aws_ecs_task_definition.this.arn : var.task_definition_arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  enable_ecs_managed_tags = true

  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_group_ids
    assign_public_ip = true
  }
  
  load_balancer {
    container_name   = var.service_name
    container_port   = var.container_port
    target_group_arn = try(var.target_group_arn, null)
  }

  dynamic "service_connect_configuration" {
    for_each = var.enable_service_connect ? [1] : []

    content {
      enabled   = true
      namespace = var.service_connect_namespace

      service {
        port_name      = var.service_name
        discovery_name = var.service_name

        client_alias {
          port     = var.container_port
          dns_name = var.service_name
        }
      }
    }
  }
}