data "aws_ssm_parameter" "app-alb_sg_id" {
  name = "/terraform/${var.project_name}/${var.environment}/app-alb_sg_id"
}

data "aws_ssm_parameter" "web-alb_sg_id" {
  name = "/terraform/${var.project_name}/${var.environment}/web-alb_sg_id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/terraform/${var.project_name}/${var.environment}/public_subnet_ids"
}

data "aws_ssm_parameter" "aws_acm_certificate" {
  name = "/terraform/${var.project_name}/${var.environment}/aws_acm_certificate"
}