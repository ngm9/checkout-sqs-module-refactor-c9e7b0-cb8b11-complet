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

variable "queues" {
  description = <<-EOT
    Map of queue definitions. Each key is a logical identifier used for the
    Terraform resource address; the value contains the base queue name and
    the maxReceiveCount for the dead-letter redrive policy. The actual
    resource name in non-prod environments is prefixed with the environment
    name. In the prod environment the name is used as-is to preserve existing
    queue identities.

    To add a new queue simply add a new entry to this map.
  EOT
  type = map(object({
    name              = string
    max_receive_count = number
  }))
  default = {
    orders_created = {
      name              = "orders-created"
      max_receive_count = 5
    }
    payments_captured = {
      name              = "payments-captured"
      max_receive_count = 5
    }
    inventory_reserved = {
      name              = "inventory-reserved"
      max_receive_count = 5
    }
  }
}
