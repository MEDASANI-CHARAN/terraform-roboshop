resource "aws_lb_target_group" "main" {
  name     = "${var.project}-${var.environment}-${var.component}" # roboshop-dev-${var.component}
  port     = local.tg_port
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  deregistration_delay = 120

  health_check {
    healthy_threshold = 2
    interval = 5
    matcher = "200-299"
    path = "/health"
    port = 8080
    timeout = 2
    unhealthy_threshold = 3
  }
}

resource "aws_instance" "main" {
  ami           = local.ami_id
  instance_type = "t2.micro"
  vpc_security_group_ids = [local.sg_id]
  subnet_id = local.private_subnet_id

  tags = merge(
    local.common_tags,
    {
    Name = "${var.project}-${var.environment}-${var.component}"
    }
  )
}

resource "terraform_data" "main" {
  triggers_replace = [
    aws_instance.main.id
  ]
  
  provisioner "file" {
    source      = "main.sh"
    destination = "/tmp/${var.component}.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.main.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/${var.component}.sh",
      "sudo sh /tmp/${var.component}.sh ${var.component} ${var.environment}"
    ]
  }
}

resource "aws_ec2_instance_state" "main" {
  instance_id = aws_instance.main.id
  state       = "stopped"
  depends_on = [ terraform_data.main ]
}

resource "terraform_data" "main_deregister_old_ami" {
  provisioner "local-exec" {
    command = "powershell -Command \"$ami = aws ec2 describe-images --owners self --filters Name=name,Values=roboshop-dev-${var.component} --query 'Images[0].ImageId' --output text; if ($ami -ne 'None') { Write-Host 'Deregistering AMI:' $ami; aws ec2 deregister-image --image-id $ami } else { Write-Host 'No AMI found to deregister.' }\""
  }

  triggers_replace = [timestamp()]
}



resource "aws_ami_from_instance" "main" {
  name               = "${var.project}-${var.environment}-${var.component}"
  source_instance_id = aws_instance.main.id
  depends_on = [ aws_ec2_instance_state.main, terraform_data.main_deregister_old_ami ]

  tags = merge(
    local.common_tags,
    {
    Name = "${var.project}-${var.environment}-${var.component}"
    }
  )
}


resource "terraform_data" "main_delete" {
  triggers_replace = [
    aws_instance.main.id
  ]
  
  # Make syre you have aws configure in your laptop
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.main.id}"
  }
  depends_on = [ aws_ami_from_instance.main ]
}


resource "aws_launch_template" "main" {
  name = "${var.project}-${var.environment}-${var.component}"

  image_id = aws_ami_from_instance.main.id

  instance_initiated_shutdown_behavior = "terminate"


  instance_type = "t2.micro"

  vpc_security_group_ids = [local.sg_id]

  tag_specifications {
    resource_type = "instance"

    tags = merge(
    local.common_tags,
    {
    Name = "${var.project}-${var.environment}-${var.component}-ec2"
    }
  )
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(
    local.common_tags,
    {
    Name = "${var.project}-${var.environment}-${var.component}-volume"
    }
  )
  }

  tags = merge(
    local.common_tags,
    {
    Name = "${var.project}-${var.environment}-${var.component}-template"
    }
  )
}


resource "aws_autoscaling_group" "main" {
  name = "${var.project}-${var.environment}-${var.component}"
  desired_capacity   = 1
  max_size           = 3
  min_size           = 1
  target_group_arns = [aws_lb_target_group.main.arn]
  vpc_zone_identifier = local.private_subnet_ids
  health_check_grace_period = 90
  health_check_type = "ELB"

  launch_template {
    id      = aws_launch_template.main.id
    version = aws_launch_template.main.latest_version
  }

  dynamic "tag" {
    for_each = merge(
    local.common_tags,
    {
    Name = "${var.project}-${var.environment}-${var.component}"
    }
  )
  content {
    key                 = tag.key
    value               = tag.value
    propagate_at_launch = true
  }
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

  timeouts {
    delete = "15m"
  }
}

resource "aws_autoscaling_policy" "main" {
  name                   = "${var.project}-${var.environment}-${var.component}"
  autoscaling_group_name = aws_autoscaling_group.main.name
  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 75.0
  }
}

resource "aws_lb_listener_rule" "main" {
  listener_arn = local.alb_listener_arn
  priority     =  var.rule_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  condition {
    host_header {
      values = local.host_header_url
    }
  }
}