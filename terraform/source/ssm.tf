resource "aws_ssm_parameter" "caller_id" {
    name = "/${local.env}/key1"
    type = "String"
    value = local.caller_id
    tags   = merge(tomap({ "Name" = join("-", [local.env, local.project]) }), tomap({ "ResourceType" = "SSM" }), local.common_tags)
    
    lifecycle {
        prevent_destroy = true
    } 
}

resource "aws_ssm_parameter" "caller_pass" {
    name = "/${local.env}/key2"
    type = "SecureString"
    key_id = module.rnd_kms_key.key_id
    value = local.caller_pass
    tags   = merge(tomap({ "Name" = join("-", [local.env, local.project]) }), tomap({ "ResourceType" = "SSM" }), local.common_tags)

    lifecycle {
        prevent_destroy = true
    }    
}

resource "aws_ssm_parameter" "sp_id" {
    name = "/${local.env}/key3"
    type = "String"
    value = local.sp_id
    tags   = merge(tomap({ "Name" = join("-", [local.env, local.project]) }), tomap({ "ResourceType" = "SSM" }), local.common_tags)


    lifecycle {
        prevent_destroy = true
    } 
}

resource "aws_ssm_parameter" "sp_pass" {
    name = "/${local.env}/key4"
    type = "SecureString"
    key_id = module.rnd_kms_key.key_id
    value = local.sp_pass
    tags   = merge(tomap({ "Name" = join("-", [local.env, local.project]) }), tomap({ "ResourceType" = "SSM" }), local.common_tags)

    lifecycle {
        prevent_destroy = true
    }
}
