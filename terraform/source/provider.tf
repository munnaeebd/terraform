terraform {
  backend "s3" {
    bucket         = "tfstate-rnd"
    key            ="terraform.tfstate"
    region         = "ap-southeast-1"

    dynamodb_table = "tfstate-rnd"
    encrypt        = true
  }
  required_providers {
    archive = {
      source = "hashicorp/archive"
    }

    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0, < 5.0.0" // Restrict using 5.x version (temporary)
    }
  }
}
provider "aws" {
  region = "ap-southeast-1"
}
# resource "aws_s3_bucket" "terraform_state" {
#   bucket = "tfstate-rnd"
#   versioning {
#     enabled = true
#   }
#   lifecycle {
#     prevent_destroy = true
#   }
# }

# resource "aws_dynamodb_table" "terraform_state_lock" {
#   name           = "tfstate-rnd"
#   read_capacity  = 1
#   write_capacity = 1
#   hash_key       = "LockID"
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}