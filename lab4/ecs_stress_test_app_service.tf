resource "aws_ecs_service" "stresstest_lab4_service" {
  name                               = "lab4-service-stresstest-app"
  cluster                            = aws_ecs_cluster.lab4_stresstest.id
  desired_count                      = 1
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  capacity_provider_strategy {
    base              = 0
    capacity_provider = aws_ecs_capacity_provider.stresstest_app_lab4_capacity_provider.name
    weight            = 1
  }

  depends_on           = [aws_autoscaling_group.lab4_stresstest_asg]
  force_new_deployment = true
  task_definition      = aws_ecs_task_definition.stresstest_app_lab4_task.arn_without_revision
}

# terraform import aws_ecs_service.stresstest_lab4_service stresstest-lab4-cluster/lab4-service-stresstest-app