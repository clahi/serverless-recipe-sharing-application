output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
  description = "The cloudfront domain name"
}