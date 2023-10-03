module "acm" {
  source                    = "../tf-modules/acm"
  domain_name               = aws_route53_zone.project-zone.name
  subject_alternative_names = ["*.${aws_route53_zone.project-zone.name}"]
  tags                      = merge(tomap({"Name" = join("-", [local.env, local.project, "wildcard-acm"])}), tomap({"ResourceType" = "acm"}), local.common_tags)
  validation_record_fqdns   = aws_route53_record.cert-validation.fqdn
}

module "virginia-acm" {
  source = "../tf-modules/acm"
  providers = {
    aws = aws.virginia
  }
  domain_name               = aws_route53_zone.project-zone.name
  subject_alternative_names = ["*.${aws_route53_zone.project-zone.name}"]
  tags                      = merge(tomap({"Name" = join("-", [local.env, local.project, "virginia-acm"])}), tomap({"ResourceType" = "acm"}), local.common_tags)
  validation_record_fqdns   = aws_route53_record.cert-validation.fqdn
}