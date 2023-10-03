output "fifo-sqs-id" {
  value = try(aws_sqs_queue.sqs-fifo[0].id, null)
}
output "sqs-id" {
  value = try(aws_sqs_queue.sqs[0].id, null)
}

output "fifo-arn" {
  value = try(aws_sqs_queue.sqs-fifo[0].arn, null)
}
output "arn" {
  value = try(aws_sqs_queue.sqs[0].arn, null)
}