variable "environment" {
  description = "Logical environment name for the checkout messaging stack."
  type        = string
  default     = "prod"
}

variable "service_name" {
  description = "Owning service for the queues."
  type        = string
  default     = "checkout"
}

variable "cost_center" {
  description = "Cost center used for chargeback reporting on all queue resources."
  type        = string
  default     = "ecom-checkout"
}
