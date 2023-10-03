module "wallets-db" {
  source                        = "../tf-modules/dynamodb"
  name                          = "${local.env}-${local.project}-wallets"
  hash_key                      = "WalletNumber"
  dynamodb_read_capacity        = local.rnd-wallets-read
  dynamodb_write_capacity       = local.rnd-wallets-write
  read_target_value             = local.rnd-wallets-read-target-value
  write_target_value            = local.rnd-wallets-write-target-value
  enable_encryption             = false
  enable_point_in_time_recovery = local.env == "prod" ? true : false
  tags = merge(tomap({"Name" = join("_", ["wallets", local.env])}), tomap({"ResourceType" = "dynamodb"}), local.common_tags)
}
module "users-db" {
  source                        = "../tf-modules/dynamodb"
  name                          = "${local.env}-${local.project}-users"
  hash_key                      = "UserId"
  dynamodb_read_capacity        = local.rnd-users-read
  dynamodb_write_capacity       = local.rnd-users-write
  read_target_value             = local.rnd-users-read-target-value
  write_target_value            = local.rnd-users-write-target-value
  enable_encryption             = false
  enable_point_in_time_recovery = local.env == "prod" ? true : false
  dynamodb_attributes = [
    {
      name = "UserId"
      type = "S"
    },
    {
      name = "PasswordUpdatedAt"
      type = "N"
    },
    {
      name = "Idx"
      type = "S"
    }    
  ]
  global_secondary_index_map = [
    {
      name = "PasswordExpirationRemainderIndex"
      hash_key = "Idx"
      range_key = "PasswordUpdatedAt"
      read_capacity = local.rnd-user-PasswordExpirationRemainderIndex-gsi-read
      write_capacity = local.rnd-user-PasswordExpirationRemainderIndex-gsi-write
      projection_type = "INCLUDE"
      non_key_attributes = ["Email", "WalletNumber"]
    }
  ]
  tags = merge(tomap({"Name" = join("_", ["users", local.env])}), tomap({"ResourceType" = "dynamodb"}), local.common_tags)
}

module "audit-log-db" {
  source                        = "../tf-modules/dynamodb"
  name                          = "${local.env}-${local.project}-audit-log"
  hash_key                      = "Id"
  dynamodb_read_capacity        = local.rnd-audit-log-read
  dynamodb_write_capacity       = local.rnd-audit-log-write
  read_target_value             = local.rnd-audit-log-read-target-value
  write_target_value            = local.rnd-audit-log-write-target-value
  enable_encryption             = false
  enable_point_in_time_recovery = local.env == "prod" ? true : false
  dynamodb_attributes = [
    {
      name = "Id"
      type = "S"
    },
    {
      name = "WalletNumber"
      type = "S"
    },
    {
      name = "ActionTime"
      type = "N"
    },
    {
      name = "Email"
      type = "S"
    },
    {
      name = "OperationType"
      type = "S"
    },
    {
      name = "TraceId"
      type = "S"
    }               
  ]
  global_secondary_index_map = [
    {
      name = "WalletNumberIndex"
      hash_key = "WalletNumber"
      range_key = "ActionTime"
      read_capacity = local.rnd-audit-log-WalletNumberIndex-gsi-read
      write_capacity = local.rnd-audit-log-WalletNumberIndex-gsi-write
      projection_type = "ALL"
      non_key_attributes = null
    },
    {
      name = "OperationTypeIndex"
      hash_key = "OperationType"
      range_key = "ActionTime"
      read_capacity = local.rnd-audit-log-OperationTypeIndex-gsi-read
      write_capacity = local.rnd-audit-log-OperationTypeIndex-gsi-write
      projection_type = "ALL"
      non_key_attributes = null
    },
    {
      name = "EmailIndex"
      hash_key = "Email"
      range_key = "ActionTime"
      read_capacity = local.rnd-audit-log-EmailIndex-gsi-read
      write_capacity = local.rnd-audit-log-EmailIndex-gsi-write
      projection_type = "ALL"
      non_key_attributes = null
    },
    {
      name = "TraceIdIndex"
      hash_key = "TraceId"
      range_key = "ActionTime"
      read_capacity = local.rnd-audit-log-TraceIdIndex-gsi-read
      write_capacity = local.rnd-audit-log-TraceIdIndex-gsi-write
      projection_type = "ALL"
      non_key_attributes = null
    }    
  ]
  tags = merge(tomap({"Name" = join("_", ["audit-log", local.env])}), tomap({"ResourceType" = "dynamodb"}), local.common_tags)
}