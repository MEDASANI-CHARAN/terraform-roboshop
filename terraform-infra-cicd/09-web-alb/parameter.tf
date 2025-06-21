resource "aws_ssm_parameter" "web_alb_listener_arn" {
  name  = "/terraform/${var.project_name}/${var.environment}/web_alb_listener_arn"
  type  = "String"
  value = aws_lb_listener.http.arn
}

resource "aws_ssm_parameter" "web_alb_listener_arn_https" {
  name  = "/terraform/${var.project_name}/${var.environment}/web_alb_listener_arn_https"
  type  = "String"
  value = aws_lb_listener.https.arn
}