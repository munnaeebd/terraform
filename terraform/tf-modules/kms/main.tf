resource "aws_kms_key" "rnd-kms-key" {
  description = var.description
  tags  = var.tags
  policy = data.aws_iam_policy_document.kms-policy-document.json

  lifecycle {
    prevent_destroy = true
  }

}


resource "aws_kms_alias" "rnd-key-alias" {
  name          = "alias/${var.alias_name}"
  target_key_id = aws_kms_key.rnd-kms-key.id
}


data "aws_iam_policy_document" "kms-policy-document" {
  version = "2012-10-17"
  statement {
    sid = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [ var.account_id ]
    }
    actions = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid = "Allow access for Key Administrators"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = var.aws_users
    }
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = ["*"]
  }
  statement {
    sid = "Allow use of the key"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = var.modules
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }
  statement {
    sid = "Allow attachment of persistent resources"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = var.modules
    }
    actions = [ "kms:CreateGrant", "kms:ListGrants", "kms:RevokeGrant" ]
    resources = ["*"]
    condition {
      test = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values = ["true"]
    }
  }

}