# iam.tf - Updated with shorter names

# IAM Role for GitHub Actions
resource "aws_iam_role" "github_deploy" {
  name = substr("github-actions-deploy-${var.bucket_name}", 0, 64)  # Truncate to 64 chars

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo}:*"
          }
        }
      }
    ]
  })

  tags = {
    Name        = "github-actions-deploy-${var.bucket_name}"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# IAM Policy with deployment permissions
resource "aws_iam_policy" "deploy" {
  name = substr("s3-cf-deploy-${var.bucket_name}", 0, 64)  # Shorter name + truncate

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.website.arn,
          "${aws_s3_bucket.website.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = "cloudfront:CreateInvalidation"
        Resource = aws_cloudfront_distribution.cdn.arn
      }
    ]
  })

  tags = {
    Name        = "s3-cf-deploy-${var.bucket_name}"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "deploy" {
  role       = aws_iam_role.github_deploy.name
  policy_arn = aws_iam_policy.deploy.arn
}