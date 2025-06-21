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
    }
}
