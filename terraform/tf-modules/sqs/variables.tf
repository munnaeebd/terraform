variable "name" {}

variable "tags" {
  type = map(string)
}

variable "fifo_queue" {
  type = bool
  default = false
}

variable "content_based_deduplication" {
  type = bool
  default = false
}

variable "deduplication_scope" {
  type = string
  default = "queue"
}

variable "visibility_timeout_seconds" {
  type = number
  default = 1
}

variable "delay_seconds" {
  type = number
  default = 1
}

variable "sse_enabled" {
  type = bool
  default = false
}

variable "message_retention_seconds" {
  type = number
  default = 345600
}

variable "message_size" {
  type = number
  default = 2048
}

variable "receive_wait_time_seconds" {
  type = number
  default = 10
}