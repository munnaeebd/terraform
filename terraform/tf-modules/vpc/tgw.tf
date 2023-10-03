resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-attachment" {
  subnet_ids         = [for subnet in keys(var.private_subnets) : aws_subnet.private[subnet].id]
  transit_gateway_id = var.tgw-id
  vpc_id             = aws_vpc.main.id
  tags               = var.tgw_tags
}