resource "aws_autoscaling_group" "lab4_app_asg" {
  name                    = "asg-lab4-app"
  capacity_rebalance      = false
  default_cooldown        = 300
  default_instance_warmup = 0
  enabled_metrics         = []
  suspended_processes     = []
  min_size                = 1
  max_size                = 3

  target_group_arns    = [aws_lb_target_group.lab4_app_tg.arn]
  termination_policies = []
  vpc_zone_identifier  = [aws_subnet.us_east_1a.id, aws_subnet.us_east_1b.id]
  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }

  launch_template {
    id      = aws_launch_template.ecs_launch_template_lab4_app.id
    version = "$Default"
  }
  #   terraform import aws_autoscaling_group.lab4_app_asg asg-lab4-app
}


resource "aws_autoscaling_group" "lab4_stresstest_asg" {
  name                      = "asg-stresstest-lab4-app"
  capacity_rebalance        = false
  default_cooldown          = 300
  default_instance_warmup   = 0
  enabled_metrics           = []
  suspended_processes       = []
  min_size                  = 1
  max_size                  = 1
  wait_for_capacity_timeout = 0


  termination_policies = []
  vpc_zone_identifier  = [aws_subnet.us_east_1a.id, aws_subnet.us_east_1b.id]
  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }

  launch_template {
    id      = aws_launch_template.ecs_launch_template_lab4_stresstest_app.id
    version = "$Default"
  }
  #   terraform import aws_autoscaling_group.lab4_stresstest_asg asg-stresstest-lab4-app
}