resource "aws_route53_zone" "project-zone" {
  name = local.project-domain-name
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "cert-validation" {
  name    = module.acm.resource_record_name
  type    = module.acm.resource_record_type
  zone_id = aws_route53_zone.project-zone.zone_id
  records = [module.acm.resource_record_value]
  ttl     = 10
}

resource "aws_route53_record" "ui-cloudfront" {
  name = local.project-domain-name
  type = "A"
  zone_id = aws_route53_zone.project-zone.zone_id
  alias {
    evaluate_target_health = false
    name = aws_cloudfront_distribution.ui-cloudfront.domain_name
    zone_id = aws_cloudfront_distribution.ui-cloudfront.hosted_zone_id
  }
}

## Hosted Zone for uat-gw.company.com
resource "aws_route53_zone" "cps_domain_zone" {
  name = local.cps-domain
  vpc {
    vpc_id = module.vpc.vpc_id
  }
  lifecycle {
    ignore_changes = [vpc]
  }
}

resource "aws_route53_record" "cps_domain" {
  count   = local.env == "lt" ? 0 : 1
  zone_id = aws_route53_zone.cps_domain_zone.zone_id
  name    = local.cps-domain
  type    = "A"
  ttl     = "300"
  records = [local.cps-ip]
}