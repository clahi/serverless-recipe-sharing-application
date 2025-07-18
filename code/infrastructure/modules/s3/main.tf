resource "aws_s3_bucket" "frontend_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = "frontend-bucket"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_website_configuration" "web_configuration" {
  bucket = aws_s3_bucket.frontend_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
  bucket = aws_s3_bucket.frontend_bucket.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Id": "PolicyForCloudFrontPrivateAccess",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePricipal",
            "Effect": "Allow",
            "Pricipal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.bucket_name}/*"
            ]
        }
    ]
  })
}