resource "aws_sqs_queue" "sqs-fifo" {
  count = var.fifo_queue ? 1 : 0
  name = var.name
  tags = var.tags
  fifo_queue = var.fifo_queue
  sqs_managed_sse_enabled = var.sse_enabled
  message_retention_seconds = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds

  delay_seconds  = var.delay_seconds
  max_message_size = var.message_size
  receive_wait_time_seconds = var.receive_wait_time_seconds
  content_based_deduplication = var.content_based_deduplication
  deduplication_scope = var.deduplication_scope
}
resource "aws_sqs_queue" "sqs" {
  count = var.fifo_queue ? 0 : 1
  name = var.name
  tags = var.tags
  fifo_queue = var.fifo_queue
  sqs_managed_sse_enabled = var.sse_enabled
  message_retention_seconds = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds

  delay_seconds  = var.delay_seconds
  max_message_size = var.message_size
  receive_wait_time_seconds = var.receive_wait_time_seconds
}