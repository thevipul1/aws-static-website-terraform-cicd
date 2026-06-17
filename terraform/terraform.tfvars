# terraform.tfvars

aws_region       = "ap-south-1"
bucket_name      = "static-hosting-bucket-06-37-16-06-2026"  # ⚠️ CHANGE THIS to something unique!
environment      = "production"
github_repo      = "thevipul1/static-webhosting"  # ⚠️ CHANGE THIS to your repo!
default_root_object = "index.html"
error_document      = "index.html"
price_class         = "PriceClass_100"