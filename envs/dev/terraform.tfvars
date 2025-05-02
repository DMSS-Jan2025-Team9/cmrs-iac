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
  }
}

repositories = {
  "ecr-cmrs-app" = {
    repository_name      = "ecr-cmrs-app"
    image_tag_mutability = "IMMUTABLE"
    tags = {
      "Environment" = "dev"
      "Project"     = "CMRS"
      "Purpose"     = "ECR for backend services"
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

cluster_name = "cmrs-ecs-cluster"
execution_role_name = "ecs-task-execution-role"
service_role_name   = "ecs-service-role"

microservices = {
  user-management = {
    container_port       = 8085
    cpu                  = 256
    memory               = 512
    desired_count        = 2
    repository_name      = "ecr-cmrs-app"
    image_version        = "v1.0.0"
    subnets_names        = ["subnet-cmrs-app-01", "subnet-cmrs-app-02"]
    security_group_names = ["sgrp-cmrs-app-01"]
  }

  course-management = {
    container_port       = 8081
    cpu                  = 256
    memory               = 512
    desired_count        = 2
    repository_name      = "ecr-cmrs-app"
    image_version        = "v1.0.0"
    subnets_names        = ["subnet-cmrs-app-01", "subnet-cmrs-app-02"]
    security_group_names = ["sgrp-cmrs-app-01"]
  }

  course-registration = {
    container_port       = 8083
    cpu                  = 256
    memory               = 512
    desired_count        = 2
    repository_name      = "ecr-cmrs-app"
    image_version        = "v1.0.0"
    subnets_names        = ["subnet-cmrs-app-01", "subnet-cmrs-app-02"]
    security_group_names = ["sgrp-cmrs-app-01"]
  }

  notification = {
    container_port       = 8084
    cpu                  = 256
    memory               = 512
    desired_count        = 1
    repository_name      = "ecr-cmrs-app"
    image_version        = "v1.0.0"
    subnets_names        = ["subnet-cmrs-app-01", "subnet-cmrs-app-02"]
    security_group_names = ["sgrp-cmrs-app-01"]
  }

  course-recommendation = {
    container_port       = 8082
    cpu                  = 256
    memory               = 512
    desired_count        = 1
    repository_name      = "ecr-cmrs-app"
    image_version        = "v1.0.0"
    subnets_names        = ["subnet-cmrs-app-01", "subnet-cmrs-app-02"]
    security_group_names = ["sgrp-cmrs-app-01"]
  }
}