module "redis" {
  source = "../tf-modules/redis"
  cluster_id = "${local.env}-${local.project}-redis"
  node_type = local.redis-instance-type
  security_group_ids = [aws_security_group.redis.id]
  engine_version = local.redis-engine-version
  parameter_group_name = "default.redis7.cluster.on"
  auth_token = local.auth_token
  subnet_ids = [module.vpc.private_subnet_ids[0], module.vpc.private_subnet_ids[1], module.vpc.private_subnet_ids[2]]
  tags = merge(tomap({"Name" = join("-",[local.env,local.project,"replication-group"])}),tomap({"ResourceType" = "redis"}),local.common_tags)
}