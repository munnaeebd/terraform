// kinesis-firehose

variable "project_name" {}

variable "shard_count" {
  type        = number
}

variable "retention_period" {
  type        = number
  default     = 24
}
variable "shard_level_metrics" {
  type        = list(string)
  default     = []
}
variable "buffer_interval" {
  type        = number
  default     = 180
}
variable "buffer_size" {
  type        = number
  default     = 2
}


