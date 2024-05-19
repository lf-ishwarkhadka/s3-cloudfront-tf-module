output "bucket_name" {
  value = aws_s3_bucket.s3_bucket.bucket
}

output "bucket_domain_name" {
  value = aws_s3_bucket.s3_bucket.bucket_domain_name
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
}

output "bucket_arn" {
  value = aws_s3_bucket.s3_bucket.arn
}

output "bucket_region" {
  value = aws_s3_bucket.s3_bucket.region
}

output "bucket_hosted_zone_id" {
  value = aws_s3_bucket.s3_bucket.hosted_zone_id
}

output "OAC_id" {
  value = aws_cloudfront_origin_access_control.cloudfront_oac.id
}

output "cloudfront_distribution_id" {
    value = aws_cloudfront_distribution.aws_cloudfront_distribution.id
}

output "cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.aws_cloudfront_distribution.arn
}

output "cloudfront_distribution_domain_name" {
  value = aws_cloudfront_distribution.aws_cloudfront_distribution.domain_name
}


