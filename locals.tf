locals {
  # Common tags intended to be applied to every queue resource.
  common_tags = {
    Service     = var.service_name
    Environment = var.environment
    CostCenter  = var.cost_center
  }

  # Compute the final queue name for each entry.
  # For the prod workspace the unprefixed name is used so that existing
  # queue identities are preserved (no destroy/replace). All other
  # workspaces get a "{workspace}-{name}" prefix.
  queue_configs = {
    for k, v in var.queues : k => {
      name              = terraform.workspace == "prod" ? v.name : "${terraform.workspace}-${v.name}"
      max_receive_count = v.max_receive_count
    }
  }
}
