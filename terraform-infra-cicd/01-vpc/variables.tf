variable "project_name" {
    type = string
    default = "expense"
}

variable "environment" {
    type = string
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

variable public_subnet_cidrs {
    type = list
    default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable private_subnet_cidrs {
    type = list
    default = ["10.0.11.0/24", "10.0.21.0/24"]
}

variable database_subnet_cidrs {
    type = list
    default = ["10.0.13.0/24", "10.0.23.0/24"]
}
