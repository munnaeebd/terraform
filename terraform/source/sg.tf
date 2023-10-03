resource "aws_security_group" "redis" {
  name = "${local.env}-${local.project}-replication-group"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port = 6379
    protocol = "tcp"
    to_port = 6379
    cidr_blocks = [local.vpc-cidr-block]
  }
  tags = merge(tomap({"Name" = join("-",[local.env,local.project,"redis"])}), tomap({"ResourceType" = "sg"}),local.common_tags)
}