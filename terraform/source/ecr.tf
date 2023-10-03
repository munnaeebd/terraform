module "ecr-mw1" {
  source = "../tf-modules/ecr"
  name   = "${local.env}-${local.project}-mw1"
  tags   = merge(tomap({"Name" = join("-", [local.env, local.project, "mw1"])}), tomap({"ResourceType" = "ecr"}), local.common_tags)
}

module "ecr-mw2" {
  source = "../tf-modules/ecr"
  name   = "${local.env}-${local.project}-mw2"
  tags   = merge(tomap({"Name" = join("-", [local.env, local.project, "mw2"])}), tomap({"ResourceType" = "ecr"}), local.common_tags)
}

module "ecr-mw3" {
  source = "../tf-modules/ecr"
  name   = "${local.env}-${local.project}-mw3"
  tags   = merge(tomap({"Name" = join("-", [local.env, local.project, "mw3"])}), tomap({"ResourceType" = "ecr"}), local.common_tags)
}
module "ecr-mw4" {
  source = "../tf-modules/ecr"
  name   = "${local.env}-${local.project}-mw4"
  tags   = merge(tomap({"Name" = join("-", [local.env, local.project, "mw4"])}), tomap({"ResourceType" = "ecr"}), local.common_tags)
}