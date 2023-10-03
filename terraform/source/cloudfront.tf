resource "aws_cloudfront_origin_access_control" "ui-s3-origin-access-control" {
  name = "${local.project}-access-control-${local.env}"
  description = "Access control for rnd UI S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}

resource "aws_cloudfront_distribution" "ui-cloudfront" {
  depends_on = [
    aws_s3_bucket.ui,
    aws_cloudfront_origin_access_control.ui-s3-origin-access-control,
    module.virginia-acm,
  ]
  provider = aws.virginia

  origin {
    origin_id   = "${local.env}-${local.project}-ui"
    domain_name = aws_s3_bucket.ui.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.ui-s3-origin-access-control.id
  }

  # If using route53 aliases for DNS we need to declare it here too, otherwise we'll get 403s.
  aliases             = [local.project-domain-name]
  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.env}-${local.project}-ui"
    compress         = true
    forwarded_values {
      headers      = ["Origin"]
      query_string = true
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
  }

  # The cheapest priceclass
  price_class = "PriceClass_200"

  # This is required to be specified even if it's not used.
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn      = module.virginia-acm.acm-arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  custom_error_response {
    error_caching_min_ttl = "86400"
    error_code            = "400"
    response_code         = "200"
    response_page_path    = "/index.html"
  }
  custom_error_response {
    error_caching_min_ttl = "86400"
    error_code            = "403"
    response_code         = "200"
    response_page_path    = "/index.html"
  }
  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "404"
    response_code         = "200"
    response_page_path    = "/index.html"
  }
  custom_error_response {
    error_caching_min_ttl = "86400"
    error_code            = "405"
    response_code         = "200"
    response_page_path    = "/index.html"
  }
  custom_error_response {
    error_caching_min_ttl = "86400"
    error_code            = "414"
    response_code         = "200"
    response_page_path    = "/index.html"
  }
  custom_error_response {
    error_caching_min_ttl = "86400"
    error_code            = "416"
    response_code         = "200"
    response_page_path    = "/index.html"
  }
  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "500"
    response_code         = "200"
    response_page_path    = "/index.html"
  }
  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "501"
    response_code         = "200"
    response_page_path    = "/index.html"
  }
  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "502"
    response_code         = "200"
    response_page_path    = "/index.html"
  }
  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "503"
    response_code         = "200"
    response_page_path    = "/index.html"
  }
  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "504"
    response_code         = "200"
    response_page_path    = "/index.html"
  }
}