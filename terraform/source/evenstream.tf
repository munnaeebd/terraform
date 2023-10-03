module "eventstream_kinesis" {
  count  = local.env == "lt" ? 0 : 1
  source = "../tf-modules/eventstream_kinesis"
  project_name = "${local.env}-rnd"
  shard_count = 1
}
