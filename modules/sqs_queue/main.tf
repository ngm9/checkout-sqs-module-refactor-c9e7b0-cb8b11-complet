# Reusable building block for a checkout SQS queue plus its dead-letter
# queue. This module exists but is not yet wired into the root
# configuration; the root still defines queues as individual resources.

resource "aws_sqs_queue" "dlq" {
  name = "${var.queue_name}-dlq"

  tags = var.tags
}

resource "aws_sqs_queue" "main" {
  name = var.queue_name

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = var.max_receive_count
  })

  tags = var.tags
}
