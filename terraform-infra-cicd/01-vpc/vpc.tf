module "vpc" {
    #source = "../01-terraform-aws-vpc"
    #source = "git::https://github.com/Medasanicharan/terraform-vpc.git?ref=main"
    source = "git::https://github.com/MEDASANI-CHARAN/terraform-aws-vpc.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    common_tags = var.common_tags
    public_subnet_cidrs = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs
    database_subnet_cidrs = var.database_subnet_cidrs
}