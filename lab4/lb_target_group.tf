resource "aws_lb_target_group" "lab4_app_tg" {
  name     = "target-group-1-app-lab2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default.id

  deregistration_delay = 60
  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = "/health"
    port                = "traffic-port"
  }
  # terraform import aws_lb_target_group.lab4_app_tg arn:aws:elasticloadbalancing:us-east-1:709190047976:targetgroup/target-group-1-app-lab2/441c78f3806c8c97
}