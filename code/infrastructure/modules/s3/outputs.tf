output "bucket_domain_name" {
  description = "THe s3 bucket domain name"
  value = aws_s3_bucket.frontend_bucket.bucket_domain_name
}