aws_region = "ap-southeast-1"
vpc_parameters = {
  vpc-cmrs-app-01 = {
    cidr_block           = "10.0.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = {
      "Environment" = "dev"
      "Project"     = "CMRS"
      "Name"        = "vpc-cmrs-app-01"
    }
  }
}

subnet_parameters = {
  subnet-cmrs-app-01 = {
    cidr_block            = "10.0.1.0/24"
    vpc_name              = "vpc-cmrs-app-01"
    availability_zone     = "ap-southeast-1a"
    map_public_ip_on_launch = true
    tags = {
      "Environment" = "dev"
      "Project"     = "CMRS"
      "Name"        = "subnet-cmrs-app-01"
    }
  },
  subnet-cmrs-app-02 = {
    cidr_block            = "10.0.2.0/24"
    vpc_name              = "vpc-cmrs-app-01"
    availability_zone     = "ap-southeast-1b"
    map_public_ip_on_launch = true
    tags = {
      "Environment" = "dev"
      "Project"     = "CMRS"
      "Name"        = "subnet-cmrs-app-02"
    }
  }
}

igw_parameters = {
  igw-cmrs-app-01 = {
    vpc_name = "vpc-cmrs-app-01"
    tags = {
      "Environment" = "dev"
      "Project"     = "CMRS"
      "Name"        = "igw-cmrs-app-01"
    }
  }
}

rt_parameters = {
  rt-cmrs-app-01 = {
    vpc_name = "vpc-cmrs-app-01"
    routes = [
      {
        cidr_block = "0.0.0.0/0"
        use_igw    = true
        gateway_name = "igw-cmrs-app-01"
      }
    ]
    tags = {
      "Environment" = "dev"
      "Project"     = "CMRS"
      "Name"        = "rt-cmrs-app-01"
    }
  }
}

rt_association_parameters = {
  assoc-cmrs-app-01 = {
    subnet_name = "subnet-cmrs-app-01"
    rt_name     = "rt-cmrs-app-01"
  },
  assoc-cmrs-app-02 = {
    subnet_name = "subnet-cmrs-app-02"
    rt_name     = "rt-cmrs-app-01"
  }
}

security_group_parameters = {
  sgrp-cmrs-app-01 = {
    name                   = "sgrp-cmrs-app-01"
    description            = "Security group of CMRS Apps"
    revoke_rules_on_delete = true
    vpc_name = "vpc-cmrs-app-01"
    tags = {
      "Environment" = "dev"
      "Project"     = "CMRS"
      "Name"        = "sgrp-cmrs-app-01"
    }
    ingress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        self        = false
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all ingress"
      }
    ]
    egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all egress"
      }
    ]
  },
  sgrp-cmrs-rds-01 = {
    name                   = "sgrp-cmrs-rds-01"
    description            = "Security group of CMRS RDS"
    revoke_rules_on_delete = true
    vpc_name = "vpc-cmrs-app-01"
    tags = {
      "Environment" = "dev"
      "Project"     = "CMRS"
      "Name"        = "sgrp-cmrs-rds-01"
    }
    ingress = [
      {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        self        = true
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow ingress to database"
      }
    ]
    egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all egress"
      }
    ]
  },
  sgrp-cmrs-rabbitmq = {
    name                   = "sgrp-cmrs-rabbitmq"
    description            = "Security group of CMRS RabbitMQ"
    revoke_rules_on_delete = true
    vpc_name = "vpc-cmrs-app-01"
    tags = {
      "Environment" = "dev"
      "Project"     = "CMRS"
      "Name"        = "sgrp-cmrs-rabbitmq"
    }
    ingress = [
      {
        from_port   = 5671
        to_port     = 5671
        protocol    = "tcp"
        self        = false
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow ingress to database"
      }
    ]
    egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all egress"
      }
    ]
  },
  sgrp-cmrs-ec2 = {
    name                   = "sgrp-cmrs-ec2"
    description            = "Security group of CMRS EC2 instance"
    revoke_rules_on_delete = true
    vpc_name = "vpc-cmrs-app-01"
    tags = {
      "Environment" = "dev"
      "Project"     = "CMRS"
      "Name"        = "sgrp-cmrs-ec2"
    }
    ingress = [
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        self        = false
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow ingress to database"
      },
      {
        from_port   = 3389
        to_port     = 3389
        protocol    = "tcp"
        self        = false
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow ingress to database"
      }
    ]
    egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all egress"
      }
    ]
  }
}

repositories = {
  "ecr-cmrs-user-management" = {
    repository_name      = "ecr-cmrs-user-management"
    image_tag_mutability = "IMMUTABLE"
    tags = {
      "Environment" = "dev"
      "Project"     = "CMRS"
      "Service"     = "user-management"
      "Purpose"     = "ECR for user-management service"
    }
    lifecycle_policy = <<EOT
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire untagged images older than 30 days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 30
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOT
  },
  "ecr-cmrs-course-management" = {
    repository_name      = "ecr-cmrs-course-management"
    image_tag_mutability = "IMMUTABLE"
    tags = {
      "Environment" = "dev"
      "Project"     = "CMRS"
      "Service"     = "course-management"
      "Purpose"     = "ECR for course-management service"
    }
    lifecycle_policy = <<EOT
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire untagged images older than 30 days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 30
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOT
  },
  "ecr-cmrs-course-registration" = {
    repository_name      = "ecr-cmrs-course-registration"
    image_tag_mutability = "IMMUTABLE"
    tags = {
      "Environment" = "dev"
      "Project"     = "CMRS"
      "Service"     = "course-registration"
      "Purpose"     = "ECR for course-registration service"
    }
    lifecycle_policy = <<EOT
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire untagged images older than 30 days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 30
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOT
  },
  "ecr-cmrs-notification" = {
    repository_name      = "ecr-cmrs-notification"
    image_tag_mutability = "IMMUTABLE"
    tags = {
      "Environment" = "dev"
      "Project"     = "CMRS"
      "Service"     = "notification"
      "Purpose"     = "ECR for notification service"
    }
    lifecycle_policy = <<EOT
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire untagged images older than 30 days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 30
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOT
  },
  "ecr-cmrs-course-recommendation" = {
    repository_name      = "ecr-cmrs-course-recommendation"
    image_tag_mutability = "IMMUTABLE"
    tags = {
      "Environment" = "dev"
      "Project"     = "CMRS"
      "Service"     = "course-recommendation"
      "Purpose"     = "ECR for course-recommendation service"
    }
    lifecycle_policy = <<EOT
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire untagged images older than 30 days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 30
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOT
  }
}

ecs_cluster = {
  cluster_name = "cmrs-ecs-cluster"
  cluster_service_connect_defaults = "cmrs-ecs-appsvc"
  vpc_name = "vpc-cmrs-app-01"
}

execution_role_name = "ecs-task-execution-role"
service_role_name   = "ecs-service-role"
log_retention_in_days = 14

load_balancer_config = {
  alb_name          = "alb-cmrs-app"
  subnets           = ["subnet-cmrs-app-01", "subnet-cmrs-app-02"]
  security_groups   = ["sgrp-cmrs-app-01"]
  vpc_name          = "vpc-cmrs-app-01"
  acm_arn           = "arn:aws:acm:ap-southeast-1:585008058878:certificate/324abf67-a92d-46b2-92c7-4c8b2f213ab4"
}

microservices = {
  user-management = {
    container_port       = 8085
    cpu                  = 256
    memory               = 512
    desired_count        = 1
    repository_name      = "ecr-cmrs-user-management"
    image_version        = "v1.0.0"
    subnets_names        = ["subnet-cmrs-app-01", "subnet-cmrs-app-02"]
    security_group_names = ["sgrp-cmrs-app-01"]
    tags = {
      "Environment" = "dev"
      "Project"     = "CMRS"
      "Service"     = "user-management"
    }
    autoscaling = {
      min_capacity      = 1
      max_capacity      = 4
      cpu_target_value  = 75
    }
    healthCheck = {
      interval    = 90
      timeout     = 30
      retries     = 3
      startPeriod = 300
    }
    enable_service_connect    = true
    service_connect_namespace = "cmrs-ecs-appsvc"
  },

  course-management = {
    container_port       = 8081
    cpu                  = 256
    memory               = 512
    desired_count        = 1
    repository_name      = "ecr-cmrs-course-management"
    image_version        = "v1.0.0"
    subnets_names        = ["subnet-cmrs-app-01", "subnet-cmrs-app-02"]
    security_group_names = ["sgrp-cmrs-app-01"]
    tags = {
      "Environment" = "dev"
      "Project"     = "CMRS"
      "Service"     = "course-management"
    }
    autoscaling = {
      min_capacity      = 1
      max_capacity      = 3
      cpu_target_value  = 75
    }
    healthCheck = {
      interval    = 90
      timeout     = 30
      retries     = 3
      startPeriod = 300
    }
    enable_service_connect    = true
    service_connect_namespace = "cmrs-ecs-appsvc"
  },

  course-registration = {
    container_port       = 8083
    cpu                  = 256
    memory               = 512
    desired_count        = 1
    repository_name      = "ecr-cmrs-course-registration"
    image_version        = "v1.0.0"
    subnets_names        = ["subnet-cmrs-app-01", "subnet-cmrs-app-02"]
    security_group_names = ["sgrp-cmrs-app-01"]
    tags = {
      "Environment" = "dev"
      "Project"     = "CMRS"
      "Service"     = "course-registration"
    }
    autoscaling = {
      min_capacity      = 1
      max_capacity      = 4
      cpu_target_value  = 75
    }
    healthCheck = {
      interval    = 90
      timeout     = 30
      retries     = 3
      startPeriod = 300
    }
    enable_service_connect    = true
    service_connect_namespace = "cmrs-ecs-appsvc"
  },

  notification = {
    container_port       = 8084
    cpu                  = 256
    memory               = 512
    desired_count        = 1
    repository_name      = "ecr-cmrs-notification"
    image_version        = "v1.0.0"
    subnets_names        = ["subnet-cmrs-app-01", "subnet-cmrs-app-02"]
    security_group_names = ["sgrp-cmrs-app-01"]
    tags = {
      "Environment" = "dev"
      "Project"     = "CMRS"
      "Service"     = "notification"
    }
    autoscaling = {
      min_capacity      = 1
      max_capacity      = 2
      cpu_target_value  = 75
    }
    healthCheck = {
      interval    = 90
      timeout     = 30
      retries     = 3
      startPeriod = 300
    }
    enable_service_connect    = true
    service_connect_namespace = "cmrs-ecs-appsvc"
  },

  course-recommendation = {
    container_port       = 8082
    cpu                  = 256
    memory               = 512
    desired_count        = 1
    repository_name      = "ecr-cmrs-course-recommendation"
    image_version        = "v1.0.0"
    subnets_names        = ["subnet-cmrs-app-01", "subnet-cmrs-app-02"]
    security_group_names = ["sgrp-cmrs-app-01"]
    tags = {
      "Environment" = "dev"
      "Project"     = "CMRS"
      "Service"     = "course-recommendation"
    }
    autoscaling = {
      min_capacity      = 1
      max_capacity      = 2
      cpu_target_value  = 75
    }
    healthCheck = {
      interval    = 90
      timeout     = 30
      retries     = 3
      startPeriod = 300
    }
    enable_service_connect    = true
    service_connect_namespace = "cmrs-ecs-appsvc"
  }
}



rds_config = {
  db_name               = "cmrsRDS"
  db_identifier         = "cmrs-rds"
  db_instance_class     = "db.t4g.micro"
  db_engine             = "mysql"
  db_engine_version     = "8.0.40"
  db_username           = "cmrs"
  db_password           = "password123"
  db_port               = 3306
  db_allocated_storage  = 20
  db_subnet_group_name  = "cmrs-db-subnet-group"
  multi_az              = false
  security_group_name   = "sgrp-cmrs-rds-01"
  subnets_names         = ["subnet-cmrs-app-01","subnet-cmrs-app-02"]
}

rabbitmq_config = {
  broker_name         = "rabbitmq-broker"
  engine_version      = "3.13"
  host_instance_type  = "mq.t3.micro"
  deployment_mode     = "SINGLE_INSTANCE"
  subnets          = ["subnet-cmrs-app-01"]
  publicly_accessible = false
  security_groups = ["sgrp-cmrs-rabbitmq"]
  username            = "rabbit_admin"
  password            = "cmrsRabbitP@55w0rd"
  configuration_data  = <<-EOT
    consumer_timeout = 1800000
  EOT
  maintenance_window = {
    day      = "MONDAY"
    time     = "18:00"
    timezone = "UTC"
  }
}

ec2_instances = [
  {
    instance_name     = "cmrs-github-runner-01"
    ami_id            = "ami-0c1907b6d738188e5" 
    instance_type     = "t2.micro"
    key_name          = "ssh-cmrs-ops-console"
    subnet_name       = "subnet-cmrs-app-01"
    security_groups   = ["sgrp-cmrs-ec2"]
    availability_zone = "ap-southeast-1a"
  },
  {
    instance_name     = "cmrs-github-runner-02"
    ami_id            = "ami-0c1907b6d738188e5" 
    instance_type     = "t2.micro"
    key_name          = "ssh-cmrs-ops-console"
    subnet_name       = "subnet-cmrs-app-02"
    security_groups   = ["sgrp-cmrs-ec2"]
    availability_zone = "ap-southeast-1b"
  }
]