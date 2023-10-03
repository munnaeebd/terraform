variable "description" {}

variable "tags" {}

variable "alias_name" {
  description = "The name of the key alias"
  type        = string
}

variable "modules" {
  description = ""
  type = list(string)
  default = []
}

variable "account_id" {
  description = "current aws account id"
  type = string
  default = ""
}

variable "aws_users" {
  description = "list of aws users to give permission enlcosed in double-quotes and comma-separated"
  type = list(string)
  default = []
}

