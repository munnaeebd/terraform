//kinesis-stream
resource "aws_kinesis_stream" "kinesis-stream" {
  name                 = "${var.project_name}-kinesis-stream"
  shard_count          = var.shard_count
  retention_period     = var.retention_period
  shard_level_metrics  = var.shard_level_metrics
  tags                 = {
    Name               = "${var.project_name}-kinesis-stream"
    Resource-Type      = "STRM"
    Environment        = regex("^[^-]*[^ -]",var.project_name)
    Version            = "0.1.0"
    Cost-Center        = "rnd"
    Project            = "rnd"
  }

}
//firehose-delivery-stream
resource "aws_kinesis_firehose_delivery_stream" "kinesis-eventstream-delivery" {
  name                 = "${var.project_name}-firehose"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.kinesis-stream.arn
    role_arn           = aws_iam_role.kinesis-firehose-role.arn
  }

  destination          = "extended_s3"

  extended_s3_configuration {
    bucket_arn         = aws_s3_bucket.db-stream-bucket.arn
    role_arn           = aws_iam_role.kinesis-firehose-role.arn
    buffer_interval    = var.buffer_interval
    buffer_size        = var.buffer_size
  }

  tags                 = {
    Name               = "${var.project_name}-firehose"
    Resource-Type      = "STRM"
    Environment        = regex("^[^-]*[^ -]",var.project_name)
    Version            = "0.1.0"
    Cost-Center        = "rnd"
    Project            = "rnd"
  }

}
