data "aws_ssm_parameter" "vpc_id" {
  name = "/terraform/${var.project_name}/${var.environment}/vpc_id"
}