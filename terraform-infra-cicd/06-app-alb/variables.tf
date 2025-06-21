variable project_name {
  default = "expense"
}

variable environment {
  default = "dev"
}

variable common_tags {
    type = map
    default = {
      Project = "expense"
      Environment = "dev"
      Terraform = "true"
      Component = "app-alb"
    }
}

variable zone_name {
  type = string
  default = "daws2025.online"
}
