resource "aws_ssm_parameter" "aws_acm_certificate" {
  name  = "/terraform/${var.project_name}/${var.environment}/aws_acm_certificate"
  type  = "String"
  value = aws_acm_certificate.expense.arn
}