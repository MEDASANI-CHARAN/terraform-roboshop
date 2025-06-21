data "aws_ssm_parameter" "app-alb_sg_id" {
  name = "/terraform/${var.project_name}/${var.environment}/app-alb_sg_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/terraform/${var.project_name}/${var.environment}/private_subnet_ids"
}
