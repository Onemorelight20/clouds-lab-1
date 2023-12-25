data "aws_iam_policy" "ssm_readonly_access" {
  name = "AmazonSSMReadOnlyAccess"
}

data "aws_iam_policy" "container_service_for_ec2_role" {
  name = "AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role" "ecs_task_role" {
  name        = "ecs-task-role"
  description = "Allows ECS tasks to call AWS services on your behalf."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    data.aws_iam_policy.ssm_readonly_access.arn,
  ]
}

resource "aws_iam_role" "ecs_instance_role" {
  name = "ecsInstanceRole"

  assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    data.aws_iam_policy.container_service_for_ec2_role.arn,
  ]
}

resource "aws_iam_instance_profile" "profile_ecs_instance_role" {
  role = aws_iam_role.ecs_instance_role.name
}

data "aws_iam_policy" "ecs_service_role_policy" {
  name = "AmazonECSServiceRolePolicy"
}

resource "aws_iam_role" "service_role_for_ecs" {
  name        = "AWSServiceRoleForECS"
  description = "Role to enable Amazon ECS to manage your cluster."
  path        = "/aws-service-role/ecs.amazonaws.com/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    data.aws_iam_policy.ecs_service_role_policy.arn,
  ]
}

# data "aws_iam_policy" "ecs_service_role_policy" {
#   name = "AmazonECSServiceRolePolicy"
# }
