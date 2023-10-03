resource "aws_elasticache_replication_group" "replica" {
  description = "Redis Encrypted Cluster"
  preferred_cache_cluster_azs = ["ap-southeast-1b"]
  engine = "redis"
  automatic_failover_enabled = true
  port = 6379
  apply_immediately = true

  auth_token = var.auth_token
  at_rest_encryption_enabled    = true
  transit_encryption_enabled    = true

  replication_group_id = var.cluster_id
  node_type = var.node_type
  num_cache_clusters = var.number_cache_clusters
  engine_version = var.engine_version
  parameter_group_name = var.parameter_group_name
  subnet_group_name = aws_elasticache_subnet_group.redis.name
  security_group_ids = var.security_group_ids
  
  tags = var.tags
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_elasticache_subnet_group" "redis" {
  name       = var.cluster_id
  subnet_ids = var.subnet_ids
}