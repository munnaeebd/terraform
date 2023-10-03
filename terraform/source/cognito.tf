resource "aws_cognito_user_pool" "userpool" {
  name                = "${local.env}-${local.project}-userpool"
  username_attributes = ["email"]
  password_policy {
    minimum_length                   = 8
    require_lowercase                = false
    require_numbers                  = false
    require_symbols                  = false
    require_uppercase                = false
    temporary_password_validity_days = 180
  }
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 2
    }
  }
  lambda_config {
    pre_sign_up = aws_lambda_function.cognito-user-auto-confirm.arn
  }
  auto_verified_attributes = ["email"]
  schema {
    attribute_data_type      = "String"
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }
  schema {
    attribute_data_type      = "String"
    mutable                  = true
    name                     = "businessName"
    required                 = false

    string_attribute_constraints {
      min_length = 1
      max_length = 100
    }
  }  
  schema {
    attribute_data_type      = "String"
    mutable                  = true
    name                     = "createdBy"
    required                 = false

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }
  schema {
    attribute_data_type      = "String"
    mutable                  = true
    name                     = "role"
    required                 = false

    string_attribute_constraints {
      min_length = 4
      max_length = 20
    }
  }
  schema {
    attribute_data_type      = "String"
    mutable                  = true
    name                     = "status"
    required                 = false

    string_attribute_constraints {
      min_length = 2
      max_length = 10
    }
  }
  schema {
    attribute_data_type      = "String"
    mutable                  = true
    name                     = "walletId"
    required                 = false

    string_attribute_constraints {
      min_length = 10
      max_length = 100
    }
  }
  schema {
    attribute_data_type      = "String"
    mutable                  = true
    name                     = "walletNumber"
    required                 = false

    string_attribute_constraints {
      min_length = 11
      max_length = 11
    }
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name = "${local.env}-${local.project}-userpool-client-app"

  user_pool_id = aws_cognito_user_pool.userpool.id
  auth_session_validity = 3 // 3 min
  generate_secret = false
  refresh_token_validity = 1 // 1 day
  access_token_validity = 1 // 1 hour
  id_token_validity = 1 // 1 hour
  # prevent_user_existence_errors = "ENABLED"
  enable_token_revocation = true
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]
  
}
