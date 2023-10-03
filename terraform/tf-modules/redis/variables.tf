variable "cluster_id" {}

variable "node_type" {}

variable "engine_version" {
  type = string
  default = "7.0"
}

variable "number_cache_clusters" {
  type = number
  default = 1
}

variable "security_group_ids" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "parameter_group_name" {
  default = "default.redis7.cluster.on"
  type = string
}
variable "auth_token" {
  type = string
}
