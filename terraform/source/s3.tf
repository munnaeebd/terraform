resource "aws_s3_bucket" "mw1" {
    bucket = "${local.env}-${local.project}-mw1"
    lifecycle {
        prevent_destroy = true
    }
    tags = {
        Name = "${local.env}-${local.project}-mw1"
        Resource_Type = "${local.env}-S3"
        Version = local.version
        Project = local.project
    }
}
resource "aws_s3_bucket_object" "mw1-certificate" {
  bucket = aws_s3_bucket.mw1.id
  key    = "certificate/"
  source = "/dev/null"
  acl    = "private"
}
resource "aws_s3_bucket" "ui" {
    bucket = "${local.env}-${local.project}-ui"
    lifecycle {
        prevent_destroy = true
    }
    tags = {
        Name = "${local.env}-${local.project}-ui"
        Resource_Type = "${local.env}-S3"
        Version = local.version
        Project = local.project
    }
}

resource "aws_s3_bucket_cors_configuration" "ui-cors-config" {
  bucket = aws_s3_bucket.ui.id
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["HEAD", "GET"]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 86400
  }
}

resource "aws_s3_bucket_versioning" "ui-versioning" {
  bucket = aws_s3_bucket.ui.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource aws_s3_bucket_public_access_block "ui-public-block" {
    bucket = aws_s3_bucket.ui.id

    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "ui-oac-access-policy" {
    bucket = aws_s3_bucket.ui.id
    policy = jsonencode({
        Version = "2008-10-17",
        Id = "PolicyForCloudFrontPrivateContent",
        Statement = [
            {
                Sid = "AllowCloudFrontServicePrincipal",
                Effect = "Allow",
                Principal = {
                    Service = "cloudfront.amazonaws.com"
                },
                Action = "s3:GetObject",
                Resource = "${aws_s3_bucket.ui.arn}/*",
                Condition = {
                    StringEquals = {
                        "AWS:SourceArn" = "${aws_cloudfront_distribution.ui-cloudfront.arn}"
                    }
                }
            }
        ]
    })
    depends_on = [ aws_cloudfront_distribution.ui-cloudfront ]
}