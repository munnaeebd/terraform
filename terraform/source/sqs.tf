module "sqs1" {
  source                     = "../tf-modules/sqs"
  fifo_queue                 = false
  sse_enabled                = true
  name                       = "${local.env}-${local.project}-sqs1"
  visibility_timeout_seconds = local.sqs1_timeout_seconds
  message_retention_seconds  = local.sqs1_message_retention_seconds
  receive_wait_time_seconds  = local.sqs1_receive_wait_time_seconds
  tags                       = merge(tomap({ "Name" = join("-", [local.env, local.project, "sqs1"]) }), tomap({ "ResourceType" = "sqs" }), local.common_tags)
}
module "sqs2" {
  source                     = "../tf-modules/sqs"
  fifo_queue                 = false
  sse_enabled                = true
  name                       = "${local.env}-${local.project}-sqs2"
  visibility_timeout_seconds = local.sqs2_timeout_seconds
  message_retention_seconds  = local.sqs2_message_retention_seconds
  receive_wait_time_seconds  = local.sqs2_receive_wait_time_seconds
  tags                       = merge(tomap({ "Name" = join("-", [local.env, local.project, "sqs2"]) }), tomap({ "ResourceType" = "sqs" }), local.common_tags)
}
module "sqs3" {
  source                     = "../tf-modules/sqs"
  fifo_queue                 = false
  sse_enabled                = true
  name                       = "${local.env}-${local.project}-sqs3"
  visibility_timeout_seconds = local.sqs3_timeout_seconds
  message_retention_seconds  = local.sqs3_message_retention_seconds
  receive_wait_time_seconds  = local.sqs3_receive_wait_time_seconds
  tags                       = merge(tomap({ "Name" = join("-", [local.env, local.project, "sqs3"]) }), tomap({ "ResourceType" = "sqs" }), local.common_tags)
}
module "sqs4" {
  source                     = "../tf-modules/sqs"
  fifo_queue                 = false
  sse_enabled                = true
  name                       = "${local.env}-${local.project}-sqs4"
  visibility_timeout_seconds = local.sqs4_timeout_seconds
  message_retention_seconds  = local.sqs4_message_retention_seconds
  receive_wait_time_seconds  = local.sqs4_receive_wait_time_seconds
  tags                       = merge(tomap({ "Name" = join("-", [local.env, local.project, "sqs4"]) }), tomap({ "ResourceType" = "sqs" }), local.common_tags)
}
