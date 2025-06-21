module db {
    #source = "../../terraform-aws-security"
    source = "git::https://github.com/MEDASANI-CHARAN/terraform-aws-security.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_description  = "SG for DB MySQL instance"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "db"
}

module backend {
    #source = "../../terraform-aws-security"
    source = "git::https://github.com/MEDASANI-CHARAN/terraform-aws-security.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_description  = "SG for Backend instance"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "backend"
}

module frontend {
    #source = "../../terraform-aws-security"
    source = "git::https://github.com/MEDASANI-CHARAN/terraform-aws-security.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_description  = "SG for frontend instance"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "frontend"
}

module bastion {
    #source = "../../terraform-aws-security"
    source = "git::https://github.com/MEDASANI-CHARAN/terraform-aws-security.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_description  = "SG for bastion instance"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "bastion"
}

module app-alb {
    #source = "../../terraform-aws-security"
    source = "git::https://github.com/MEDASANI-CHARAN/terraform-aws-security.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_description  = "SG for app_alb instance"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "app-alb"
}

module web-alb {
    #source = "../../terraform-aws-security"
    source = "git::https://github.com/MEDASANI-CHARAN/terraform-aws-security.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_description  = "SG for web_alb instance"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "web-alb"
}

module vpn {
    #source = "../../terraform-aws-security"
    source = "git::https://github.com/MEDASANI-CHARAN/terraform-aws-security.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_description  = "SG for vpn instance"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "vpn"
    ingress_rules = var.vpn_sg_rules
}

# DB is accepting cnnections from backend
resource "aws_security_group_rule" "db_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.backend.sg_id
  security_group_id = module.db.sg_id
}

# DB is accepting cnnections from bastion
resource "aws_security_group_rule" "db_bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.db.sg_id
}

# DB is accepting cnnections from bastion
resource "aws_security_group_rule" "db_vpn" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.db.sg_id
}

# Backend is accepting cnnections from frontend
resource "aws_security_group_rule" "backend_app_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app-alb.sg_id
  security_group_id = module.backend.sg_id
}

# Backend is accepting cnnections from bastion
resource "aws_security_group_rule" "backend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.backend.sg_id
}

# Backend is accepting cnnections from vpn_ssh
resource "aws_security_group_rule" "backend_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.backend.sg_id
}

# Backend is accepting cnnections from vpn_http
resource "aws_security_group_rule" "backend_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.backend.sg_id
}

# frontend is accepting cnnections from web_alb
resource "aws_security_group_rule" "frontend_web_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web-alb.sg_id
  security_group_id = module.frontend.sg_id
}

# Frontend is accepting cnnections from public
resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.frontend.sg_id
}

# Frontend is accepting cnnections from bastion
resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.frontend.sg_id
}

# Frontend is accepting cnnections from vpn
resource "aws_security_group_rule" "frontend_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.frontend.sg_id
}

# bastion is accepting cnnections from public
resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}

# app_alb is accepting cnnections from vpn
resource "aws_security_group_rule" "app_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.app-alb.sg_id
}

# app_alb is accepting cnnections from bastion
resource "aws_security_group_rule" "app_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.app-alb.sg_id
}

# app_alb is accepting cnnections from frontend
resource "aws_security_group_rule" "app_alb_frontend" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id
  security_group_id = module.app-alb.sg_id
}

# web_alb is accepting cnnections from public
resource "aws_security_group_rule" "web_alb_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.web-alb.sg_id
}

# web_alb is accepting cnnections from https
resource "aws_security_group_rule" "web_alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.web-alb.sg_id
}

# Backend is accepting cnnections from default_vpc
resource "aws_security_group_rule" "backend_default_vpc" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["172.31.0.0/16"]
  security_group_id = module.backend.sg_id
}

# Frontend is accepting cnnections from default_vpc
resource "aws_security_group_rule" "frontend_default_vpc" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["172.31.0.0/16"]
  security_group_id = module.frontend.sg_id
}