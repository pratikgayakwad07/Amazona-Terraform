resource "aws_cloudfront_origin_access_control" "s3_oac" {

  name                              = "${var.project_name}-${var.environment}-oac"

  origin_access_control_origin_type = "s3"

  signing_behavior                  = "always"

  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {

  enabled             = true

  default_root_object = "index.html"

  # S3 FRONTEND ORIGIN


  origin {

    domain_name = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name

    origin_id   = "s3-origin"

    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
  }

  
  # ALB BACKEND ORIGIN
  
  origin {

    domain_name = var.alb_dns_name

    origin_id   = "alb-origin"

    custom_origin_config {

      http_port              = 80

      https_port             = 443

      origin_protocol_policy = "http-only"

      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  # DEFAULT FRONTEND CACHE BEHAVIOR

  default_cache_behavior {

    target_origin_id = "s3-origin"

    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]


    compress = true

    forwarded_values {

      query_string = false

      cookies {
        forward = "none"
      }
    }
  }
  
  # API REVERSE PROXY

  ordered_cache_behavior {

    path_pattern = "/api/*"

    target_origin_id = "alb-origin"

    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS",
      "PUT",
      "POST",
      "PATCH",
      "DELETE"
    ]

    cached_methods = [
      "GET",
      "HEAD"
    ]

    compress = true

    forwarded_values {

      query_string = true

      headers = ["*"]

      cookies {
        forward = "all"
      }
    }

    min_ttl     = 0

    default_ttl = 0

    max_ttl     = 0
  }

  # SSL

  viewer_certificate {

    cloudfront_default_certificate = true
  }

  # GEO RESTRICTIONS

  restrictions {

    geo_restriction {

      restriction_type = "none"
    }
  }

}