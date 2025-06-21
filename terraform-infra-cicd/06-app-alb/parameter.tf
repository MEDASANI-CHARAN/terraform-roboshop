resource "aws_ssm_parameter" "app_alb_listener_arn" {
  name  = "/terraform/${var.project_name}/${var.environment}/app_alb_listener_arn"
  type  = "String"
  value = aws_lb_listener.http.arn
}