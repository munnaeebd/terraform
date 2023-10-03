resource "aws_s3_bucket" "db-stream-bucket" {
  bucket            = "${var.project_name}-dbstream"
}
resource "aws_s3_bucket_lifecycle_configuration" "db-stream-bucket-config" {
  bucket = aws_s3_bucket.db-stream-bucket.bucket
  rule {
    id = "config"
    noncurrent_version_transition {
      noncurrent_days = 90
      storage_class   = "DEEP_ARCHIVE"
    }
    status = "Enabled"
  }
}