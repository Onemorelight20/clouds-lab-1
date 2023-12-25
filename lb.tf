resource "aws_lb" "lab4_app_lb" {
  name                       = "lab4-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.default.id]
  subnets                    = [aws_subnet.us_east_1a.id, aws_subnet.us_east_1b.id]
  enable_deletion_protection = false

  #   terraform import aws_lb.lab4_app_lb arn:aws:elasticloadbalancing:us-east-1:709190047976:loadbalancer/app/lab4-lb/4fb08d7a8cb99952
}

resource "aws_lb_listener" "lab4_app_lb_listener" {
  load_balancer_arn = aws_lb.lab4_app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lab4_app_tg.arn
  }
}