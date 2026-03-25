# NoSQL Trade-off Analysis

**CS 6500 — Assignment 3, Part 3**

---

## 1. Schema Design Philosophy

<!-- Discuss embedding vs. references (MongoDB) vs. denormalization (Cassandra).
     Reference your own schema choices — for example, why you embedded items in orders
     vs. why you created separate tables in Cassandra for each access pattern. -->

...

## 2. CAP Positioning

<!-- MongoDB is CP; Cassandra is AP. Explain what that means in practice.
     Then explain how CONSISTENCY QUORUM (R + W > RF) achieves strong consistency
     in Cassandra despite its AP classification.
     Ground this in your specific RF=3 setup. -->

...

## 3. Query Flexibility

<!-- Compare MQL's aggregation pipeline (used in Part 1) with CQL's
     one-table-per-query constraint (used in Part 2).
     What would you have to do if a new access pattern emerged after deployment? -->

...

## 4. Write vs. Read Performance

<!-- Compare Cassandra's SSTable/memtable write path with MongoDB's WiredTiger.
     What are the throughput implications for high-volume click ingestion?
     Which system would you choose for 100,000 writes/second and why? -->

...

## 5. When to Use Each

<!-- Give one concrete scenario where MongoDB is the better choice and one where
     Cassandra is the better choice. Be specific — name the access patterns,
     scale requirements, and consistency needs that drive your decision. -->

### Choose MongoDB when:

...

### Choose Cassandra when:

...
