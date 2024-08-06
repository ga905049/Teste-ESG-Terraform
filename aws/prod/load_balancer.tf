resource "aws_lb" "app-lb" {
  name               = "app"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-app-sg.id]
  subnets            = module.vpc_producao.public_subnets

}

resource "aws_lb_target_group" "app-tg" {
  name     = "app-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = module.vpc_producao.vpc_id

  health_check {
    path                = "/"
    port                = 3000
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 2
    interval            = 5
    matcher             = "200"
  }
}

resource "aws_lb_target_group_attachment" "app-tg-attach" {
  target_group_arn = aws_lb_target_group.app-tg.arn
  target_id        = aws_instance.docker-server.id
  port             = 3000
}

resource "aws_alb_listener" "app-listener" {

  load_balancer_arn = aws_lb.app-lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-tg.arn
  }
}
