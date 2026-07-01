## State / Migration Note — SQS Queue Module Refactor

### What changed
The three checkout queue pairs were refactored from six flat `aws_sqs_queue` resources into a single reusable module (`modules/sqs_queue`) driven by `var.queues`. Each queue is now at address `module.checkout_queues["<key>"]`.

### Why the prod plan stays clean (assuming state moves are done)
In the `prod` workspace, `var.environment == "prod"`, so `local.queue_configs` uses the bare queue name (e.g. `"orders-created"`) — matching the existing live queue names exactly. The workspace prefix `"prod-"` is NOT applied in prod. This means the AWS queue names are unchanged, and Terraform sees no name-driven replacement.

Non-prod workspaces (e.g. `staging`) still get the prefix (`"staging-orders-created"`) for environment isolation.

### Required state moves (run before `terraform apply` in `prod`)
These are required because even though the remote resources are still the same, they now sit at a different config on the terraform project, given they have been migrated from individual resource blocks to the list/map based one.
Run these commands *in order* in the `prod` workspace to remap state addresses:

```bash
terraform state mv aws_sqs_queue.orders_created       'module.checkout_queues["orders_created"].aws_sqs_queue.main'
terraform state mv aws_sqs_queue.orders_created_dlq    'module.checkout_queues["orders_created"].aws_sqs_queue.dlq'
terraform state mv aws_sqs_queue.payments_captured     'module.checkout_queues["payments_captured"].aws_sqs_queue.main'
terraform state mv aws_sqs_queue.payments_captured_dlq 'module.checkout_queues["payments_captured"].aws_sqs_queue.dlq'
terraform state mv aws_sqs_queue.inventory_reserved     'module.checkout_queues["inventory_reserved"].aws_sqs_queue.main'
terraform state mv aws_sqs_queue.inventory_reserved_dlq 'module.checkout_queues["inventory_reserved"].aws_sqs_queue.dlq'
```

After the moves, `terraform plan` should show zero changes.
