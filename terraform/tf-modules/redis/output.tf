output "endpoint" {
  value = aws_elasticache_replication_group.replica.primary_endpoint_address
}