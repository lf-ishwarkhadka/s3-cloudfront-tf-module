resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name

}

resource "aws_cloudfront_origin_access_control" "cloudfront_oac" {
  name                              = var.OAC_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "aws_cloudfront_distribution" {
  origin {
    domain_name              = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_oac.id
    origin_id                = aws_s3_bucket.s3_bucket.bucket_domain_name
  }

  enabled             = true
  is_ipv6_enabled     = true

  aliases = var.cloudfront_aliases

  default_cache_behavior {
    allowed_methods  = var.allowed_methods
    cached_methods   = var.cached_methods
    target_origin_id = aws_s3_bucket.s3_bucket.bucket_domain_name

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = aws_s3_bucket.s3_bucket.bucket_domain_name

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.locations
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}


data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    effect = "Allow"
    actions = [ "s3:GetObject" ]
    resources = [ "${aws_s3_bucket.s3_bucket.arn}/*", aws_s3_bucket.s3_bucket.arn ]
    principals {
      type = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test = "StringEquals"
      variable = "AWS:SourceArn"
      values = [aws_cloudfront_distribution.aws_cloudfront_distribution.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy_attachment" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}
