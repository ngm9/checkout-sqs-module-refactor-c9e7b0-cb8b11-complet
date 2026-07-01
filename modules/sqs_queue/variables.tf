variable "queue_name" {
  description = "Name of the primary queue. The dead-letter queue is derived from this."
  type        = string
}

variable "max_receive_count" {
  description = "Number of receives before a message is moved to the dead-letter queue."
  type        = number
  default     = 5
}

variable "tags" {
  description = "Tags applied to the queue and its dead-letter queue."
  type        = map(string)
  default     = {}
}
