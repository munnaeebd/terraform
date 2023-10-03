variable "env" {}
variable "project" {}
variable "subnet-ids" {}
variable "tags" {
  type = map(string)
}
# variable "security_groups" {
#   type = list(string)
# }
variable "eks-version" {}
variable "vpc_id" {
  type = string
}
variable "vpc-cidr-block" {
  type = string
}
variable "ondemand_min_size" {
  type = number
}
variable "ondemand_max_size" {
  type = number
}
variable "ondemand_desired_size" {
  type = number
}
#variable "node_role_arn" {}
variable "worker_node_role_arn" {
  type = string
}
variable "node_group_instance_types" {
  type = list(string)
}
variable "spot_min_size" {
  type = number
}
variable "spot_max_size" {
  type = number
}
variable "spot_desired_size" {
  type = number
}
