locals {
  s3_origin_id = "mys3Origion"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = var.aws_bucket_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_access.id
    origin_id = local.s3_origin_id
  }

  enabled = true
  is_ipv6_enabled = true
  comment = "enabled"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400

  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern = "/content/immutable/*"
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl = 0
    default_ttl = 86400
    max_ttl = 31536000
    compress = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "blacklist"
      locations = ["US"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_origin_access_control" "s3_access" {
  name = "s3_access"
  description = "cloudfront access conrol"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}

