// firehose
resource "aws_iam_policy" "kinesis-firehose-policy" {
  name               = "${var.project_name}-firehose-kinesis-policy"
  policy             = data.aws_iam_policy_document.kinesis-firehose-policy-document.json
}
data "aws_iam_policy_document" "kinesis-firehose-policy-document" {
  version            = "2012-10-17"
  statement {
    sid              = ""
    effect           = "Allow"
    actions          = ["glue:GetTableVersions"]
    resources        = ["*"]
  }
  statement {
    sid              = ""
    effect           = "Allow"
    actions          = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
    resources        = [
      aws_s3_bucket.db-stream-bucket.arn,
      "${aws_s3_bucket.db-stream-bucket.arn}/*",
      "arn:aws:s3:::%FIREHOSE_BUCKET_NAME%",
      "arn:aws:s3:::%FIREHOSE_BUCKET_NAME%/*"
    ]
  }

  statement {
    sid              = ""
    effect           = "Allow"
    actions          = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords"
    ]
    resources        = [aws_kinesis_stream.kinesis-stream.arn]
  }
}
resource "aws_iam_role" "kinesis-firehose-role" {
  name               = "${var.project_name}-kinesis-firehose-role"
  assume_role_policy = data.aws_iam_policy_document.kinesis-firehose-assume-policy-document.json
}
data "aws_iam_policy_document" "kinesis-firehose-assume-policy-document" {
  version            = "2012-10-17"
  statement {
    sid              = ""
    effect           = "Allow"
    principals {
      type           = "Service"
      identifiers    = ["firehose.amazonaws.com"]
    }
    actions          = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role_policy_attachment" "kinesis-firehose" {
  policy_arn         = aws_iam_policy.kinesis-firehose-policy.arn
  role               = aws_iam_role.kinesis-firehose-role.name
}

resource "aws_iam_policy" "kinesis-policy" {
  name               = "${var.project_name}-kinesis-policy"
  policy             = data.aws_iam_policy_document.kinesis-policy-document.json
}
data "aws_iam_policy_document" "kinesis-policy-document" {
  version            = "2012-10-17"
  statement {
    sid              = "Stmt1562858686533"
    effect           = "Allow"
    actions          = [
      "kinesis:AddTagsToStream",
      "kinesis:DescribeStream",
      "kinesis:DescribeStreamConsumer",
      "kinesis:DescribeStreamSummary",
      "kinesis:DisableEnhancedMonitoring",
      "kinesis:EnableEnhancedMonitoring",
      "kinesis:GetRecords",
      "kinesis:GetShardIterator",
      "kinesis:IncreaseStreamRetentionPeriod",
      "kinesis:ListShards",
      "kinesis:ListStreamConsumers",
      "kinesis:ListStreams",
      "kinesis:ListTagsForStream",
      "kinesis:MergeShards",
      "kinesis:PutRecord",
      "kinesis:PutRecords",
      "kinesis:RegisterStreamConsumer",
      "kinesis:SplitShard",
      "kinesis:SubscribeToShard",
      "kinesis:UpdateShardCount"
    ]
    resources        = [aws_kinesis_stream.kinesis-stream.arn]
  }
}