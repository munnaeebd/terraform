resource "aws_iam_role" "default" {
  name = var.name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_instance_profile" "default" {
  name       = var.name
  role       = var.name
  depends_on = [aws_iam_role.default]
}

resource "aws_iam_role_policy_attachment" "default" {
  for_each   = var.policies
  role       = aws_iam_role.default.name
  policy_arn = each.value
  depends_on = [aws_iam_role.default]
}
