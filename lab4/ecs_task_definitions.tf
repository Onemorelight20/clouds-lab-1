resource "aws_ecs_task_definition" "rest_app_lab4_task" {
  family = "rest-app-lab2-task"

  container_definitions = jsonencode([
    {
      name        = "lab4-container"
      image       = "${aws_ecrpublic_repository.rest_app.repository_uri}:latest"
      environment = []
      mountPoints = []
      essential   = true
      portMappings = [
        {
          appProtocol   = "http"
          name          = "lab2-container-80-tcp"
          protocol      = "tcp"
          containerPort = 80
          hostPort      = 80
        },
        {
          containerPort = 3306
          hostPort      = 3306
          name          = "lab2-container-3306-tcp"
          protocol      = "tcp"
        }
      ]

      secrets = [
        {
          name      = "SPRING_DATASOURCE_PASSWORD"
          valueFrom = aws_ssm_parameter.db_password.arn
        },
        {
          name      = "SPRING_DATASOURCE_URL"
          valueFrom = aws_ssm_parameter.db_url.arn
        },
        {
          name      = "SPRING_DATASOURCE_USERNAME"
          valueFrom = aws_ssm_parameter.db_username.arn
        }
      ]
    }
  ])

  cpu                = "512"
  memory             = "512"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  task_role_arn = aws_iam_role.ecs_task_role.arn

  requires_compatibilities = ["EC2"]
  tags                     = {}
}


resource "aws_ecs_task_definition" "stresstest_app_lab4_task" {
  family = "stresstest-lab4"
  container_definitions = jsonencode([
    {
      name             = "stress-container"
      image            = "${aws_ecrpublic_repository.stresstest_app.repository_uri}:latest"
      cpu              = 0
      environment      = []
      mountPoints      = []
      essential        = true
      environmentFiles = []
      portMappings = [
        {
          appProtocol   = "http"
          containerPort = 80
          hostPort      = 80
          name          = "stress-container-80-tcp"
          protocol      = "tcp"
        },
        {
          appProtocol   = "http"
          containerPort = 8089
          hostPort      = 8089
          name          = "stress-container-8089-tcp"
          protocol      = "tcp"
        },
        {
          appProtocol   = "http"
          name          = "stress-container-5557-tcp"
          protocol      = "tcp"
          containerPort = 5557
          hostPort      = 5557
        },

      ]

      ulimits = []

      secrets = [
        {
          name      = "USER_EMAIL"
          valueFrom = data.aws_ssm_parameter.stress_user_email.arn
        },
        {
          name      = "USER_PASSWORD"
          valueFrom = data.aws_ssm_parameter.stress_user_password.arn
        }
      ]
    }
  ])

  cpu                = "512"
  memory             = "512"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  task_role_arn = aws_iam_role.ecs_task_role.arn

  requires_compatibilities = ["EC2"]
  tags                     = {}
}