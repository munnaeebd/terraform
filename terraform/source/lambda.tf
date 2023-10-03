data "archive_file" "cognito_user_auto_confirm_script" {
#  count       = local.env == "prod" ? 1 : 0 // Don't execute if not 'prod' environment
  source_dir  = "${path.module}/lambda-code/cognito-user-auto-confirm"
  output_path = "${path.module}/lambda-code/cognito-user-auto-confirm/cognito-user-auto-confirm.zip"
  type        = "zip"
}
# Create Lambda function
resource "aws_lambda_function" "cognito-user-auto-confirm" {
  function_name = "${local.env}-${local.project}-cognito-user-auto-confirm"
  runtime = "nodejs18.x"
  handler = "index.handler"
  filename = data.archive_file.cognito_user_auto_confirm_script.output_path
  role = aws_iam_role.lambda-iam-role.arn
#   environment {
#     variables = {
#       var1 = "value1"
#       var2 = "vaule2"
#     }
#   }
  tags = {
    Name        = "${local.env}-cognito-user-auto-confirm"
    Environment = local.env
    Version     = local.version
    Cost-Center = local.cost-center
    Project     = local.project
  }
}

resource "aws_lambda_permission" "cognito-user-auto-confirm" {
#  count         = local.env == "prod" ? 1 : 0 // Don't execute if not 'prod' environment
  statement_id  = "AllowExecutionFromCognitoUserPool"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cognito-user-auto-confirm.function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.userpool.arn
}


### Credential Renewal Reminder
data "archive_file" "credential-renewal-reminder" {
#  count       = local.env == "prod" ? 1 : 0 // Don't execute if not 'prod' environment
  source_dir  = "${path.module}/lambda-code/credential-renewal-reminder"
  output_path = "${path.module}/lambda-code/credential-renewal-reminder/credential-renewal-reminder.zip"
  type        = "zip"
}
# Create Lambda function
resource "aws_lambda_function" "credential-renewal-reminder" {
  function_name = "${local.env}-${local.project}-credential-renewal-reminder"
  runtime = "python3.9"
  handler = "main.lambda_handler"
  filename = data.archive_file.credential-renewal-reminder.output_path
  role = aws_iam_role.lambda-iam-role.arn
  environment {
    variables = {
      DAYS_REMAINING_THRESHOLD = "170"
      EMAIL_QUEUE_URL = module.email-queue.sqs-id
      PASSWORD_RESET_QUEUE_URL = module.password-reset-queue.sqs-id
      USER_TABLE = "${local.env}-${local.project}-users"
    }
  }
  tags = {
    Name        = "${local.env}-credential-renewal-reminder"
    Environment = local.env
    Version     = local.version
    Cost-Center = local.cost-center
    Project     = local.project
  }
}

resource "aws_cloudwatch_event_rule" "credential-renewal-reminder-rule" {
#  count               = local.env == "prod" ? 1 : 0 // Don't execute if not 'prod' environment
  name                = "${local.env}-${local.project}-credential-renewal-reminder"
  description         = "Trigger daily at 01:00 UTC+6 to trigger lambda for credential-renewal-reminder"
  schedule_expression = "cron(0 19 * * ? *)" // Recurrence: 19:00 UTC or 01:00 Asia/Dhaka time
}

resource "aws_cloudwatch_event_target" "credential_renewal_reminder_target" {
  arn       = aws_lambda_function.credential-renewal-reminder.arn
  rule      = aws_cloudwatch_event_rule.credential-renewal-reminder-rule.name
  target_id = "${local.env}-${local.project}-credential-renewal-reminder"
}

resource "aws_lambda_permission" "credential-renewal-reminder" {
#  count         = local.env == "prod" ? 1 : 0 // Don't execute if not 'prod' environment
  statement_id  = "AllowExecutionFromCognitoUserPool"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.credential-renewal-reminder.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.credential-renewal-reminder-rule.arn
}