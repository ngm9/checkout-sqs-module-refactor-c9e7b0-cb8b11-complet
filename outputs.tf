# The checkout deployment module needs to read the URL and ARN of each
# queue so the application can publish events. Today only a subset is
# exposed.
output "orders_created_queue_url" {
  description = "URL of the orders-created queue."
  value       = aws_sqs_queue.orders_created.url
}

output "payments_captured_queue_arn" {
  description = "ARN of the payments-captured queue."
  value       = aws_sqs_queue.payments_captured.arn
}
