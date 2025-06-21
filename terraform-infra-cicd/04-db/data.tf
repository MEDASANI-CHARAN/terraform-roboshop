
data "aws_ssm_parameter" "db_sg_id" {
  name = "/terraform/${var.project_name}/${var.environment}/db_sg_id"
}

data "aws_ssm_parameter" "database_subnet_group_name" {
  name = "/terraform/${var.project_name}/${var.environment}/database_subnet_group_name"
}


