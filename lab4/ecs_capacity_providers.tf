resource "aws_ecs_capacity_provider" "lab4_app_capacity_provider" {
  name = "lab4-cp"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.lab4_app_asg.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      status          = "ENABLED"
      target_capacity = 100
    }
  }
  #   terraform import aws_ecs_capacity_provider.lab4_app_capacity_provider lab4-cp
}


resource "aws_ecs_capacity_provider" "stresstest_app_lab4_capacity_provider" {
  name = "lab4-stresstest-cp"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.lab4_stresstest_asg.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      status          = "ENABLED"
      target_capacity = 100
    }
  }
  #   terraform import aws_ecs_capacity_provider.stresstest_app_lab4_capacity_provider lab4-stresstest-cp
}