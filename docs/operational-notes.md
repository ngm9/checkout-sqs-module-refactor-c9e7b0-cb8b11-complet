# Checkout Messaging — Operational Notes

## Environments
- `prod` is the only workspace with live traffic today; `staging` is provisioned occasionally for load tests.
- The live production queue names are unprefixed: `orders-created`, `payments-captured`, `inventory-reserved`, each with a `-dlq` counterpart.

## Safety expectations
- SQS queues in `prod` hold in-flight checkout events. Replacing a queue (destroy + create) loses those messages and breaks the checkout flow.
- Any change whose plan shows a queue being destroyed or replaced must be reviewed by a senior engineer before apply. The goal for routine refactors is a clean plan with no destroys.

## Standards
- Every queue and dead-letter queue must carry `Service`, `Environment`, and `CostCenter` tags. `CostCenter` feeds chargeback reporting and is currently inconsistent.
- Dead-letter handling should be uniform: each queue redrives to its own dead-letter queue with an agreed retry threshold.

## Collaboration
- Other teams add new event queues to this stack. A new queue should be addable by editing a single input collection, not by copying resource blocks.
- Document any state moves or migration steps in the PR description so reviewers can confirm safety before a real apply.
