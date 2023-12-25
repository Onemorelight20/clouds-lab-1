resource "aws_ecs_service" "lab4_service" {
  name                              = "lab4-service-app"
  deployment_maximum_percent        = 300
  enable_ecs_managed_tags           = true
  health_check_grace_period_seconds = 40
  propagate_tags                    = "NONE"
  cluster                           = aws_ecs_cluster.lab4cluster.id
  task_definition                   = aws_ecs_task_definition.rest_app_lab4_task.arn_without_revision
  desired_count                     = 1
  iam_role                          = aws_iam_role.service_role_for_ecs.arn
  depends_on                        = [data.aws_iam_policy.ecs_service_role_policy]


  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_controller {
    type = "ECS"
  }

  capacity_provider_strategy {
    base              = 0
    capacity_provider = aws_ecs_capacity_provider.lab4_app_capacity_provider.name
    weight            = 1
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.lab4_app_tg.arn
    container_name   = "lab4-container"
    container_port   = 80
  }

  placement_constraints {
    type = "distinctInstance"
  }
}

# terraform import aws_ecs_service.lab4_service lab2/lab4-service-app