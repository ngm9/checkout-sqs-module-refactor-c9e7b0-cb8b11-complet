# Checkout queue outputs consumed by the checkout deployment module.
# Each queue's URL, ARN, and DLQ ARN is exposed in a typed map keyed by
# the logical queue identifier (orders_created, payments_captured,
# inventory_reserved). Adding a new entry to var.queues automatically
# adds it to this output — no changes needed in outputs.tf.
#
# Consumers can reference individual values directly:
#   module.checkout_queues["orders_created"].queue_url

output "checkout_queues" {
  description = <<-EOT
    Map of queue information for all checkout queues. Each entry contains:
    - queue_url: URL of the primary queue.
    - queue_arn: ARN of the primary queue.
    - dlq_arn:   ARN of the dead-letter queue.
  EOT
  value = {
    for k, q in module.checkout_queues : k => {
      queue_url = q.queue_url
      queue_arn = q.queue_arn
      dlq_arn   = q.dlq_arn
    }
  }
}
