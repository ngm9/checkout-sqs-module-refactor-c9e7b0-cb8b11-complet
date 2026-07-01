# Checkout SQS Messaging — Reusable Module Refactor

## Task Overview
ShopNest's checkout service publishes domain events to three SQS queues (`orders-created`, `payments-captured`, `inventory-reserved`), each backed by a dead-letter queue, defined in this repository. The queue blocks were copy-pasted and have since drifted: dead-letter wiring and `maxReceiveCount` are inconsistent, the required `CostCenter` tag is missing in places, and a recent rename has caused the `prod` plan to propose destroying and recreating live queues. This matters because recreating an in-use SQS queue would discard in-flight checkout events. The repository is already present and runnable against a local emulator — your job is to make it maintainable and safe, not to rebuild it.

## Objectives
- The three queues are defined as near-duplicate blocks, which makes them drift apart and hard to extend; after your work, the queues should be driven from a single reusable definition so a new queue can be added by editing one input collection.
- The dead-letter behavior is inconsistent across queues (one redrive target is broken and the retry threshold varies), which means some failed messages will not land in their dead-letter queue; a resolved state has uniform, predictable dead-letter handling for every queue.
- Several resources are missing the organization's required cost-tracking tag, which breaks chargeback reporting; after your changes every queue and dead-letter queue carries the required tags consistently.
- The current `prod` plan proposes destroying and recreating existing queues, which would drop live checkout messages; the resolved plan must leave the existing queue identities intact with no destroy or replace.
- The checkout deployment module needs each queue's URL and ARN, but these are not all exposed cleanly today; after your work the consuming module can read every queue's URL and ARN from outputs.

## Helpful Tips
- Review the provided plan excerpt closely and identify which queues are being destroyed versus recreated and why their addresses or names changed.
- Think about how naming differences between the existing live resources and the refactored configuration affect whether Terraform sees a rename or a replacement.
- Consider how a single collection of queue definitions, combined with consistent shared settings, removes the duplication and keeps dead-letter and tagging behavior uniform.
- Explore how the local emulator is reachable on `127.0.0.1:4566`; you can inspect emulated queues and tags to confirm behavior without real cloud access.
- Analyze where required tags should be applied once and inherited, rather than repeated per resource where they can be forgotten.

## How to Verify
- `terraform fmt -check` and `terraform validate` both pass cleanly on the repository.
- A `prod` workspace plan shows no queues being destroyed or replaced — existing queue identities are preserved.
- Every queue and its dead-letter queue carries the required cost-tracking tag and a consistent dead-letter configuration.
- Adding a hypothetical fourth queue requires editing only the single input collection, with no new copied resource blocks.
- Outputs expose a URL and ARN for each queue in a shape the checkout deployment module can consume.
- The repository or your submission includes a short note describing the state or migration steps needed before a real `prod` apply.