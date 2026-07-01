# Checkout messaging infrastructure for the ShopNest checkout service.
#
# These queues carry checkout domain events. Each queue is paired with a
# dead-letter queue. The three queues are defined by a single reusable
# module driven by an input map, so adding a new queue requires editing
# only the var.queues map.
#
# Existing production queue names (already live, must remain stable):
#   orders-created / orders-created-dlq
#   payments-captured / payments-captured-dlq
#   inventory-reserved / inventory-reserved-dlq
#
# The prod workspace uses unprefixed names to preserve existing queue
# identities. Non-prod workspaces add the environment prefix.

# ---------------------------------------------------------------------------
# Reusable module — one instance per queue in the input map
# ---------------------------------------------------------------------------
module "checkout_queues" {
  source   = "./modules/sqs_queue"
  for_each = local.queue_configs

  queue_name        = each.value.name
  max_receive_count = each.value.max_receive_count
  tags              = local.common_tags
}
