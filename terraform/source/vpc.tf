module "vpc" {
  source = "../tf-modules/vpc"
  vpc_cidr_block                 = local.vpc-cidr-block
  domain_name                    = local.vpc-domain-name
  public_subnets                 = local.public-subnets
  public_route_table_tags        = merge(tomap({"Name" = join("-", [local.env, local.project, "public"])}), tomap({"ResourceType" = "ROUTE-TABLE"}), local.common_tags)
  private_subnets                = local.private-subnets
  private_route_table_tags       = merge(tomap({"Name" = join("-", [local.env, local.project, "private"])}), tomap({"ResourceType" = "ROUTE-TABLE"}), local.common_tags)
  tgw-routes                     = merge(local.other-vpc-block, local.company-private-blocks) ## if multiple routes needed through tgw
  tgw-id                         = local.transit-gateway-id
  vpc_tags    = merge(tomap({"Name" = join("-", [local.env, local.project, "vpc"])}), tomap({"ResourceType" = "VPC"}), local.common_tags)
  igw_tags    = merge(tomap({"Name" = join("-", [local.env, local.project, "igw"])}), tomap({"ResourceType" = "IGW"}), local.common_tags)
  eip_tags    = merge(tomap({"Name" = join("-", [local.env, local.project, "eip"])}), tomap({"ResourceType" = "EIP"}), local.common_tags)
  nat_gw_tags = merge(tomap({"Name" = join("-", [local.env, local.project, "nat-gw"])}), tomap({"ResourceType" = "NAT GW"}), local.common_tags)
  tgw_tags    = merge(tomap({"Name" = join("-", [local.env, local.project, "tgw"])}), tomap({"ResourceType" = "transit-gateway-attachment"}), local.common_tags)
}