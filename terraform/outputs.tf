# outputs.tf - All Terraform outputs

# S3 Bucket Outputs
output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.website.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.website.arn
}

output "bucket_domain_name" {
  description = "The domain name of the S3 bucket"
  value       = aws_s3_bucket.website.bucket_domain_name
}

output "versioning_status" {
  description = "Versioning status of the bucket"
  value       = aws_s3_bucket_versioning.versioning.versioning_configuration[0].status
}

# CloudFront Outputs
output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.cdn.id
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name"
  value       = aws_cloudfront_distribution.cdn.domain_name
}

output "website_url" {
  description = "Website URL"
  value       = "https://${aws_cloudfront_distribution.cdn.domain_name}"
}

# IAM Outputs
output "github_actions_role_arn" {
  description = "IAM role ARN for GitHub Actions (add to GitHub secret AWS_DEPLOY_ROLE_ARN)"
  value       = aws_iam_role.github_deploy.arn
}

output "github_oidc_provider_arn" {
  description = "GitHub OIDC provider ARN"
  value       = aws_iam_openid_connect_provider.github.arn
}

# Deployment Instructions
output "deployment_instructions" {
  description = "Instructions for GitHub Actions setup"
  value = <<-EOT
    ============================================
    🚀 DEPLOYMENT INSTRUCTIONS
    ============================================
    
    1️⃣ Add these secrets to your GitHub repository:
       Settings → Secrets and Variables → Actions
    
       🔐 AWS_DEPLOY_ROLE_ARN = ${aws_iam_role.github_deploy.arn}
       📦 S3_BUCKET_NAME      = ${aws_s3_bucket.website.id}
       🌐 CLOUDFRONT_DISTRIBUTION_ID = ${aws_cloudfront_distribution.cdn.id}
       🌍 CLOUDFRONT_DOMAIN_NAME = ${aws_cloudfront_distribution.cdn.domain_name}
    
    2️⃣ Your website is available at:
       🌍 https://${aws_cloudfront_distribution.cdn.domain_name}
    
    3️⃣ To deploy, push to main branch:
       git add .
       git commit -m "Deploy website"
       git push origin main
    
    4️⃣ To view outputs anytime:
       terraform output
    
    ============================================
  EOT
}