module "rnd_kms_key" {
  source      = "../tf-modules/kms"
  description = "rnd-kms-key"
  alias_name  = "${local.env}-rnd-key-alias"
  modules = [
    module.eks-iam.aws_iam_role_arn,
  ]

  account_id = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"

  aws_users = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/user@example.com"
  ]

  tags = merge(tomap({ "Name" = join("-", [local.env, local.project, "rnd-kms-key"]) }), tomap({ "ResourceType" = "KMS" }), local.common_tags)
}


