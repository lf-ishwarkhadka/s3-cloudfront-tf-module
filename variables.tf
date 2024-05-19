variable "bucket_name" {
    description = "name of the bucket being created"
    type = string
}

variable "OAC_name" {
    description = "name of cloudfront OAC"
    type = string
}

variable "allowed_methods" {
  type = set(string)
}

variable "cached_methods" {
  type = set(string)
}

variable "cloudfront_aliases" {
  type = set(string)
  description = "aliases to cloudfront"
}

variable "geo_restriction_type" {
  type = string
  default = "none"
}

variable "locations" {
    type = set(string)
    description = "list of blacklisted or whitelisted locations" 
}