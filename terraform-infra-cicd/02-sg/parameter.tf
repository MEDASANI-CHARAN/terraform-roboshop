resource "aws_ssm_parameter" "db_sg_id" {
  name  = "/terraform/${var.project_name}/${var.environment}/db_sg_id"
  type  = "String"
  value = module.db.sg_id
}

resource "aws_ssm_parameter" "backend_sg_id" {
  name  = "/terraform/${var.project_name}/${var.environment}/backend_sg_id"
  type  = "String"
  value = module.backend.sg_id
}

resource "aws_ssm_parameter" "frontend_sg_id" {
  name  = "/terraform/${var.project_name}/${var.environment}/frontend_sg_id"
  type  = "String"
  value = module.frontend.sg_id
}

resource "aws_ssm_parameter" "bastion_sg_id" {
  name  = "/terraform/${var.project_name}/${var.environment}/bastion_sg_id"
  type  = "String"
  value = module.bastion.sg_id
}

resource "aws_ssm_parameter" "vpn_sg_id" {
  name  = "/terraform/${var.project_name}/${var.environment}/vpn_sg_id"
  type  = "String"
  value = module.vpn.sg_id
}

resource "aws_ssm_parameter" "app-alb_sg_id" {
  name  = "/terraform/${var.project_name}/${var.environment}/app-alb_sg_id"
  type  = "String"
  value = module.app-alb.sg_id
}

resource "aws_ssm_parameter" "web-alb_sg_id" {
  name  = "/terraform/${var.project_name}/${var.environment}/web-alb_sg_id"
  type  = "String"
  value = module.web-alb.sg_id
}
