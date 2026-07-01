locals {
  # Common tags intended to be applied to every queue resource. Not all
  # resources currently reference these.
  common_tags = {
    Service     = var.service_name
    Environment = var.environment
    CostCenter  = var.cost_center
  }
}
