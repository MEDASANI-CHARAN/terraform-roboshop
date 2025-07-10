locals {
  sg_id = data.aws_ssm_parameter.sg_id.value
  common_tags = {
    Project = var.project
    Environment = var.environment
    Terraform = "true"
  }
  ami_id = data.aws_ami.ami_id.id
  vpc_id = data.aws_ssm_parameter.vpc_id.value

  private_subnet_id = split(",", data.aws_ssm_parameter.private_subnet_ids.value)[0]
  public_subnet_id = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
  # subnet_id = "${var.component}" == "frontend" ? local.public_subnet_id : local.private_subnet_id


  private_subnet_ids = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  public_subnet_ids =  split(",", data.aws_ssm_parameter.public_subnet_ids.value)
  # subnet_ids = "${var.component}" == "frontend" ? local.public_subnet_ids : local.private_subnet_ids

  backend_alb_listener_arn = data.aws_ssm_parameter.backend_alb_listener_arn.value
  frontend_alb_listener_arn = data.aws_ssm_parameter.frontend_alb_listener_https_arn.value
  alb_listener_arn = "${var.component}" == "frontend" ? local.frontend_alb_listener_arn : local.backend_alb_listener_arn

  tg_port = "${var.component}" == "frontend" ? 80 : 8080
  health_check_path = "${var.component}" == "frontend" ? "/" : "/health"

  host_header_url = "${var.component}" == "frontend" ? ["${var.environment}.${var.zone_name}"] : ["${var.component}.backend-${var.environment}.${var.zone_name}"]

  # host_ip = "${var.component}" == "frontend" ? aws_instance.main.public_ip : aws_instance.main.private_ip
}