output "kinesis_stream_arn" {
  description = "The Amazon Resource Name (ARN) specifying the Stream"
  value       = aws_kinesis_stream.kinesis-stream.arn
}

//iam
output "arn" {
  value       = aws_iam_policy.kinesis-policy.arn
}

//s3
output "db_stream_bucket_arn" {
  description = "The Amazon Resource Name (ARN) specifying the Stream"
  value       = aws_s3_bucket.db-stream-bucket.arn
}
