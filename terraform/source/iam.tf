module "eks-iam" {
  source = "../tf-modules/iam"
  name   = "${local.env}-${local.project}-worker"
  policies = {
    EKSDefaultPolicy                   = aws_iam_policy.k8s-default-policy.arn
    EventstreamCrossAccountRole        = aws_iam_policy.cross-account.arn
    AWSSQSLimitedAccessPolicy          = aws_iam_policy.sqs_policy.arn
    AmazonS3LimitedAccess              = aws_iam_policy.eks_s3_access.arn
    AmazonDynamoDBLimitedAccess        = aws_iam_policy.eks_dynamodb_access.arn
    KMSLimitedAccess                   = aws_iam_policy.rnd_kms_policy.arn
    # AWSRoute53FullAccess               = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
    AmazonEKSWorkerNodePolicy          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    # AmazonS3FullAccess                 = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    AmazonEC2FullAccess                = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
    AmazonSSMFullAccess                = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
    AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  }
}

resource "aws_iam_policy" "cross-account" {
  name   = "${local.env}-${local.project}-cross-account"
  policy = <<EOF
{
  "Version"   : "2012-10-17",
  "Statement" : [{
    "Effect"  : "Allow",
    "Action"  : "sts:AssumeRole",
    "Resource": [ "arn:aws:iam::130968365599:role/${local.env}-${local.project}-cross-role" ]
  }]
}
EOF
}

resource "aws_iam_policy" "k8s-default-policy" {
  name   = "${local.env}-${local.project}-k8s-default-policy"
  policy = file("./aws-iam-policy-for-k8s-default.json")
}

# Create lambda policy to attach to the IAM role for cognito
resource "aws_iam_role" "lambda-iam-role" {
  name               = "${local.env}-${local.project}-lambda-iam-role"
  assume_role_policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
     {
       "Action": "sts:AssumeRole",
       "Principal": {
         "Service": [
           "lambda.amazonaws.com"
         ]
       },
       "Effect": "Allow",
       "Sid": ""
     }
   ]
}
 EOF

}
# Attach lambda policies to IAM role
resource "aws_iam_role_policy_attachment" "lambda_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda-iam-role.name
}
resource "aws_iam_role_policy_attachment" "lambda_role_policy_db_sqs_access" {
  policy_arn = aws_iam_policy.lambda_db_sqs_access.arn
  role       = aws_iam_role.lambda-iam-role.name
}

## Load Balancer Controller

data "aws_iam_policy_document" "aws_load_balancer_controller_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks-cluster.openID_connect_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }

    principals {
      identifiers = [module.eks-cluster.openID_connect_arn]
      type        = "Federated"
    }
  }
}
resource "aws_iam_role" "aws_load_balancer_controller" {
  assume_role_policy = data.aws_iam_policy_document.aws_load_balancer_controller_assume_role_policy.json
  name               = "${local.project}-aws-load-balancer-controller"
}
resource "aws_iam_policy" "aws_load_balancer_controller" {
  policy = file("./aws-iam-policy-for-lb-controller.json")
  name   = "${local.project}-AWSLoadBalancerControllerPolicy"
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_attach" {
  role       = aws_iam_role.aws_load_balancer_controller.name
  policy_arn = aws_iam_policy.aws_load_balancer_controller.arn
}

## External DNS

data "aws_iam_policy_document" "external_dns_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks-cluster.openID_connect_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:external-dns"]
    }

    principals {
      identifiers = [module.eks-cluster.openID_connect_arn]
      type        = "Federated"
    }
  }
}
resource "aws_iam_role" "external_dns" {
  assume_role_policy = data.aws_iam_policy_document.external_dns_assume_role_policy.json
  name               = "${local.project}-external-dns"
}
## Route53 access policy for EKS cluster(External DNS)

resource "aws_iam_policy" "eks_external_dns_access" {
    name   = "${local.project}-eks-route53-access"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:*"
            ],
            "Resource": [
                "${aws_route53_zone.project-zone.arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "route53:ListHostedZones",
                "route53:ListHostedZonesByName"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "external_dns_attach" {
  role       = aws_iam_role.external_dns.name
  policy_arn = aws_iam_policy.eks_external_dns_access.arn
}

## SQS Policy

resource "aws_iam_policy" "sqs_policy" {
  name   = "${local.env}-${local.project}-sqs-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "sqs:DeleteMessage",
                "sqs:GetQueueUrl",
                "sqs:ListDeadLetterSourceQueues",
                "sqs:ChangeMessageVisibility",
                "sqs:PurgeQueue",
                "sqs:ReceiveMessage",
                "sqs:DeleteQueue",
                "sqs:SendMessage",
                "sqs:GetQueueAttributes",
                "sqs:ListQueueTags",
                "sqs:CreateQueue",
                "sqs:SetQueueAttributes"
            ],
            "Resource": "arn:aws:sqs:ap-southeast-1:*:${local.env}-${local.project}-*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "sqs:ListQueues",
            "Resource": "*"
        }
    ]
}
EOF
}

## S3 access policy for EKS cluster

resource "aws_iam_policy" "eks_s3_access" {
    name   = "${local.env}-${local.project}-eks-s3-access"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": [
                "arn:aws:s3:::${local.env}-${local.project}-*",
                "arn:aws:s3:::${local.env}-${local.project}-*/*"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "*"
        }
    ]
}
EOF
}

## DynamoDB access policy for EKS cluster

resource "aws_iam_policy" "eks_dynamodb_access" {
    name   = "${local.env}-${local.project}-eks-dynamodb-access"
    policy = <<EOF
{
    "Statement": [
        {
            "Action": [
                "dynamodb:BatchGetItem",
                "dynamodb:BatchWriteItem",
                "dynamodb:ConditionCheckItem",
                "dynamodb:PutItem",
                "dynamodb:DeleteItem",
                "dynamodb:GetItem",
                "dynamodb:Scan",
                "dynamodb:ListTagsOfResource",
                "dynamodb:Query",
                "dynamodb:UpdateItem"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:dynamodb:ap-southeast-1:797962984373:table/${local.env}-${local.project}-*"
            ],
            "Sid": "VisualEditor0"
        },
        {
            "Action": [
                "dynamodb:ListTables",
                "dynamodb:ListStreams"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "VisualEditor2"
        }
    ],
    "Version": "2012-10-17"
}
EOF
}

## KMS Policy for KMS role ##
resource "aws_iam_policy" "rnd_kms_policy" {
  name = "${local.env}-${local.project}-kms-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "kms:EnableKeyRotation",
          "kms:EnableKey",
          "kms:ImportKeyMaterial",
          "kms:Decrypt",
          "kms:ListKeyPolicies",
          "kms:UpdateKeyDescription",
          "kms:ListRetirableGrants",
          "kms:GetKeyPolicy",
          "kms:GenerateDataKeyWithoutPlaintext",
          "kms:CancelKeyDeletion",
          "kms:ListResourceTags",
          "kms:DisableKey",
          "kms:ReEncryptFrom",
          "kms:DisableKeyRotation",
          "kms:ListGrants",
          "kms:UpdateAlias",
          "kms:GetParametersForImport",
          "kms:Encrypt",
          "kms:GetKeyRotationStatus",
          "kms:ScheduleKeyDeletion",
          "kms:GenerateDataKey",
          "kms:ReEncryptTo",
          "kms:DescribeKey"
        ],
        "Resource" : [
          "${module.rnd_kms_key.arn}"
        ]
      },
      {
        "Sid" : "VisualEditor1",
        "Effect" : "Allow",
        "Action" : [
          "kms:DescribeCustomKeyStores",
          "kms:ListKeys",
          "kms:GenerateRandom",
          "kms:UpdateCustomKeyStore",
          "kms:ListAliases",
          "kms:DisconnectCustomKeyStore",
          "kms:ConnectCustomKeyStore"
        ],
        "Resource" : "*"
      }
    ]
  })
}

## DynamoDB and SQS access policy for Lambda (rnd-credential-renewal-reminder)

resource "aws_iam_policy" "lambda_db_sqs_access" {
    name   = "${local.env}-${local.project}-lambda-db-sqs-access"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "sqs:DeleteQueue",
                "sqs:SendMessage",
                "dynamodb:Query"
            ],
            "Resource": [
                "arn:aws:sqs:ap-southeast-1:797962984373:${local.env}-${local.project}-*",
                "arn:aws:dynamodb:ap-southeast-1:797962984373:table/${local.env}-${local.project}-mw2",
                "arn:aws:dynamodb:ap-southeast-1:797962984373:table/${local.env}-${local.project}-mw2/index/*"
            ]
        }
    ]
}
EOF
}