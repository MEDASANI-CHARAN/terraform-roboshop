module "openvpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "Openvpn"
  key_name = aws_key_pair.vpn.key_name

  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  subnet_id              = local.public_subnet_id
  ami = data.aws_ami.ami_id.id

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-vpn"
    }
  )
}

resource "aws_key_pair" "vpn" {
  key_name   = "openvpn"
  #public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDKn/Qp7JLx4yoHpx5fBi2BZzv8bVve4eIiCjWixW4xi Windows 11@DESKTOP-EBDUG3F"
  public_key = file("~/.ssh/vpn.pub")
}