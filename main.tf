# Checkout messaging infrastructure for the ShopNest checkout service.
#
# These queues carry checkout domain events. Each queue is paired with a
# dead-letter queue. The blocks below were originally created by copying a
# single queue definition and editing the names. A recent change introduced
# a workspace prefix on the queue names.
#
# Existing production queue names (already live, must remain stable):
#   orders-created / orders-created-dlq
#   payments-captured / payments-captured-dlq
#   inventory-reserved / inventory-reserved-dlq

# ---------------------------------------------------------------------------
# orders-created
# ---------------------------------------------------------------------------
resource "aws_sqs_queue" "orders_created_dlq" {
  name = "${terraform.workspace}-orders-created-dlq"

  tags = {
    Service     = "checkout"
    Environment = terraform.workspace
    CostCenter  = "ecom-checkout"
  }
}

resource "aws_sqs_queue" "orders_created" {
  name = "${terraform.workspace}-orders-created"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.orders_created_dlq.arn
    maxReceiveCount     = 5
  })

  tags = {
    Service     = "checkout"
    Environment = terraform.workspace
    CostCenter  = "ecom-checkout"
  }
}

# ---------------------------------------------------------------------------
# payments-captured
# ---------------------------------------------------------------------------
resource "aws_sqs_queue" "payments_captured_dlq" {
  name = "${terraform.workspace}-payments-captured-dlq"

  tags = {
    Service     = "checkout"
    Environment = terraform.workspace
  }
}

resource "aws_sqs_queue" "payments_captured" {
  name = "${terraform.workspace}-payments-captured"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.payments_captured_dlq.arn
    maxReceiveCount     = 3
  })

  tags = {
    Service     = "checkout"
    Environment = terraform.workspace
  }
}

# ---------------------------------------------------------------------------
# inventory-reserved
# ---------------------------------------------------------------------------
resource "aws_sqs_queue" "inventory_reserved_dlq" {
  name = "${terraform.workspace}-inventory-reserved-dlq"

  tags = {
    Service     = "checkout"
    Environment = terraform.workspace
  }
}

resource "aws_sqs_queue" "inventory_reserved" {
  name = "${terraform.workspace}-inventory-reserved"

  # NOTE: redrive target points at the orders DLQ here.
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.orders_created_dlq.arn
    maxReceiveCount     = 10
  })

  tags = {
    Service     = "checkout"
    Environment = terraform.workspace
  }
}
