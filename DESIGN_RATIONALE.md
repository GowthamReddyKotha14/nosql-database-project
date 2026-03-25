# Design Rationale

**CS 6500 — Assignment 3**
**Author:** [Your Name]

---

## MongoDB Design Decisions

### Embedding vs. Reference Choice

<!-- Explain why you embedded line items inside order documents (instead of a
     separate line_items collection) and why you used a reference for user_id
     (instead of embedding the full user document). What access patterns drove
     these decisions? What are the trade-offs? -->

...

### Index Strategy

<!-- For each index you created, explain which query or aggregation it supports
     and why you chose that index key order. Include the relevant explain()
     output fields (stage, totalKeysExamined, totalDocsExamined) that confirm
     the index is being used. -->

...

## Cassandra Design Decisions

### Partition Key Choices

<!-- For each table, explain why you chose that partition key.
     Discuss partition size implications — especially for orders_by_user_date
     (composite key) vs. clicks_by_user (single key). -->

...

### Clustering Order Choices

<!-- Explain why you chose DESC clustering order for order_ts and click_ts.
     What query benefit does it provide? -->

...

## AI Use Disclosure

<!-- Required. If you used an AI assistant (ChatGPT, GitHub Copilot, Claude, etc.)
     at any point, describe: what you used it for, what it produced, and what you
     changed or verified yourself. If you did not use AI assistance, state that here. -->

...
