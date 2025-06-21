data "aws_cloudfront_cache_policy" "cache_enable" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_cache_policy" "cache_disable" {
  name = "Managed-CachingDisabled"
}

data "aws_ssm_parameter" "aws_acm_certificate" {
  name = "/terraform/${var.project_name}/${var.environment}/aws_acm_certificate"
}