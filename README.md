<<<<<<< HEAD
# Static Site on S3 + CloudFront (Terraform + GitHub Actions)

Serves a static website from a **private** S3 bucket through **CloudFront**,
using Origin Access Control (OAC) so the bucket is never public. Deploys
auto-trigger on push via GitHub Actions using short-lived OIDC credentials
(no AWS access keys stored anywhere).

## Architecture

```
GitHub push (main) -> GitHub Actions (OIDC) -> S3 (private bucket)
                                                      |
                                              CloudFront (OAC) -> Viewer
```

## 1. Drop your site in

Put your existing static website files (`index.html`, css, js, images, etc.)
into the `site/` folder, replacing the placeholder.

## 2. Set up Terraform

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars: set a globally-unique bucket_name and your github_repo

terraform init
terraform plan
terraform apply
```

This creates:
- A private S3 bucket (versioned, encrypted, public access fully blocked)
- A CloudFront distribution with OAC, using the default `*.cloudfront.net` domain
- A bucket policy that only allows that specific CloudFront distribution to read objects
- A custom error response mapping 403/404 -> `index.html` (so deep links don't break)
- An IAM OIDC provider + role scoped to your GitHub repo, with just enough
  permissions to sync to that one bucket and invalidate that one distribution

## 3. Note the outputs

```bash
terraform output
```

You'll need `cloudfront_domain_name`, `bucket_name`, and `github_actions_role_arn`.

## 4. Add GitHub repo secrets

In your GitHub repo: Settings -> Secrets and variables -> Actions -> New repository secret

| Secret name | Value |
|---|---|
| `AWS_DEPLOY_ROLE_ARN` | `github_actions_role_arn` output |
| `S3_BUCKET_NAME` | `bucket_name` output |
| `CLOUDFRONT_DISTRIBUTION_ID` | `cloudfront_distribution_id` output |

## 5. Push to deploy

Push any change under `site/` to `main`. The workflow in
`.github/workflows/deploy.yml` will:
1. Sync `site/` to S3 (`--delete` removes stale files)
2. Invalidate the CloudFront cache so viewers see the update immediately

## 6. Visit your site

```bash
terraform output website_url
```

## Notes / talking points for interviews

- **OAC over OAI**: OAC is the current AWS-recommended way to let CloudFront
  read from a private S3 bucket (OAI is the older, now-deprecated mechanism).
- **No static AWS keys in CI**: the GitHub Actions role is assumed via OIDC,
  scoped to this one repo and these two resources only — least privilege.
- **SPA-safe routing**: 403/404 from S3 get rewritten to `index.html` with a
  200 at the CloudFront layer, which is the standard pattern for client-side
  routed apps (React Router, etc.) even though this is a plain static site.
- **No custom domain yet**: this uses CloudFront's own certificate. Adding a
  domain later just means an ACM cert (us-east-1, since CloudFront requires
  that region) + Route 53 alias record + `aliases` block on the distribution.

## Tear down

```bash
cd terraform
terraform destroy
```
=======
# aws-static-website-terraform-cicd
Secure and scalable static website hosting on AWS using Terraform, S3, CloudFront, OAC, and GitHub Actions with OIDC-based CI/CD automation.
>>>>>>> 1bc1ec8add3a1deae5b58a3082a36d2a4cf78e0a
