resource "aws_launch_template" "ecs_launch_template_lab4_app" {
  name          = "ECSLaunchTemplateAppLab4"
  key_name      = "ec2-web-server"
  image_id      = "ami-0fec9863172e50c93"
  instance_type = "t2.micro"


  user_data = base64encode("#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.lab4cluster.name} >> /etc/ecs/ecs.config;")

  iam_instance_profile {
    arn = aws_iam_instance_profile.profile_ecs_instance_role.arn
  }
}

resource "aws_launch_template" "ecs_launch_template_lab4_stresstest_app" {
  name          = "ECSLaunchTemplateStresstestApp"
  key_name      = "ec2-web-server"
  image_id      = "ami-0fec9863172e50c93"
  instance_type = "t2.micro"


  user_data = base64encode("#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.lab4_stresstest.name} >> /etc/ecs/ecs.config;")

  iam_instance_profile {
    arn = aws_iam_instance_profile.profile_ecs_instance_role.arn
  }
}