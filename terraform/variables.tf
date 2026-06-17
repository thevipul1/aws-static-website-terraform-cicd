# variables.tf - All configuration variables

variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "ap-south-1"
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name for the static site (lowercase, no underscores)"
  type        = string
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "production"
}

variable "default_root_object" {
  description = "Default object CloudFront returns for the root URL"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "Object returned for 403/404 errors (also doubles as SPA fallback routing)"
  type        = string
  default     = "index.html"
}

variable "price_class" {
  description = "CloudFront price class. PriceClass_100 = NA/EU edge locations only (cheapest)"
  type        = string
  default     = "PriceClass_100"
}

variable "github_repo" {
  description = "GitHub repo allowed to assume the deploy role, in 'owner/repo' format"
  type        = string
}