# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "website_bucket" {
  # Bucket Naming Rules 
  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html
  # we want to assign a random bucket name
  # bucket = var.bucket_name
  tags = {
    UserUuid = var.user_uuid 
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration
resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.website_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${var.public_path}/index.html"
  content_type = "text/html"
  etag = filemd5("${var.public_path}/index.html")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}

resource "aws_s3_object" "upload_assets" {
  for_each = fileset("${var.public_path}/assets","*.{jpg,png,gif}")
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "assets/${each.key}"
  source = "${var.public_path}/assets/${each.key}"
  etag = filemd5("${var.public_path}/assets/${each.key}")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}
resource "aws_s3_object" "upload_pages" {
  for_each = fileset("${var.public_path}/pages","*.{html}")
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "pages/${each.key}"
  source = "${var.public_path}/pages/${each.key}"
  etag = filemd5("${var.public_path}/pages/${each.key}")
  content_type = "text/html"
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}

resource "aws_s3_object" "upload_css" {
  for_each = fileset("${var.public_path}/pages/css","*.{css}")
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "pages/css/${each.key}"
  source = "${var.public_path}/pages/css/${each.key}"
  etag = filemd5("${var.public_path}/pages/css/${each.key}")
  content_type = "text/css"
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object
resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "error.html"
  source = "${var.public_path}/error.html"
  content_type = "text/html"
  etag = filemd5("${var.public_path}/error.html")
}

resource "aws_s3_object" "styles_css" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "styles.css"
  source = "${var.public_path}/styles.css"
  content_type = "text/css"
  etag = filemd5("${var.public_path}/styles.css")
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.bucket
#   policy = data.aws_iam_policy_document.allow_access_from_another_account.json
  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = {
        "Sid" = "AllowCloudFrontServicePrincipalReadOnly",
        "Effect" = "Allow",
        "Principal" = {
            "Service" = "cloudfront.amazonaws.com"
        },
        "Action" = "s3:GetObject",
        "Resource" = "arn:aws:s3:::${aws_s3_bucket.website_bucket.id}/*",
        "Condition" = {
            "StringEquals" = {
                #"AWS:SourceArn": aws_cloudfront_distribution.s3_distribution.arn
                "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
            }
        }
    }
  })
}

resource "terraform_data" "content_version" {
  input = var.content_version
}


