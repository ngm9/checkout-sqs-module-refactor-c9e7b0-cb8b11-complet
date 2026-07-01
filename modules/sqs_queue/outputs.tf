output "queue_url" {
  description = "URL of the primary queue."
  value       = aws_sqs_queue.main.url
}

output "queue_arn" {
  description = "ARN of the primary queue."
  value       = aws_sqs_queue.main.arn
}

output "dlq_arn" {
  description = "ARN of the dead-letter queue."
  value       = aws_sqs_queue.dlq.arn
}
