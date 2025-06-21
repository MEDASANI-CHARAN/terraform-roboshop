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
      Component = "acm"
    }
}

variable zone_name {
  default = "daws2025.online"
}

variable zone_id {
  default = "Z07416722EK0JW5B66VOJ"
}