# MongoDB vs Cassandra: Comparative Analysis

## Topic 1: Schema Design Philosophy — Embedding, References, and Denormalization

MongoDB and Cassandra take fundamentally different approaches to schema design, each shaped by their underlying data model and performance goals.

In MongoDB, the document model allows two strategies: **embedding** and **references**. Embedding places related data directly inside a parent document — for example, storing order line items as an array within the order document itself. This is ideal when data is always accessed together, has a bounded size, and has a clear ownership relationship. References, by contrast, store a scalar identifier (such as `user_id`) pointing to a document in another collection, which mirrors the relational foreign-key pattern. In this assignment, orders embed their `items` array (since items have no independent lifecycle) while referencing users via a scalar `user_id`. This hybrid approach — **embed what you own, reference what you share** — keeps queries fast and the schema intuitive.

Cassandra's wide-column model takes **denormalization** to an extreme. Because Cassandra does not support joins or ad hoc filtering, data must be duplicated into separate tables that each serve a single, predetermined access pattern. For instance, `orders_by_user_date` and `revenue_by_category_date` store overlapping order data but are each optimized for a different query. This is known as **query-first schema design**: you define your queries first, then design tables to serve them exactly. The cost is data duplication and more complex write logic; the benefit is predictable, fast reads at massive scale.

The practical implication: MongoDB schema design is entity-centric and flexible, while Cassandra schema design is query-centric and rigid.

---

## Topic 2: CAP Theorem and Consistency Trade-offs

The **CAP theorem** states that a distributed system can guarantee at most two of the following three properties simultaneously: Consistency, Availability, and Partition Tolerance.

MongoDB is primarily a **CP database**. It prioritizes consistency and partition tolerance over availability. In a network partition, MongoDB's primary election mechanism may briefly make the system unavailable rather than risk returning stale data. With replica sets, all writes go to the primary, ensuring a consistent view of the data. MongoDB also supports tunable read preferences (e.g., reading from secondaries) at the cost of potential staleness, giving developers some flexibility.

Cassandra is a **AP database** by default. It prioritizes availability and partition tolerance, meaning it will continue accepting reads and writes even during a network partition, potentially returning stale data. Consistency is tunable per operation through consistency levels. `CONSISTENCY ONE` returns results from a single replica — fast but possibly stale. `CONSISTENCY QUORUM` requires a majority of replicas to agree — slower but much stronger. `CONSISTENCY ALL` requires every replica to respond — provides the strongest consistency but sacrifices availability.

For an e-commerce system, this matters deeply: order writes might use QUORUM to avoid overselling inventory, while click-tracking reads might use ONE to maximize throughput and availability.

---

## Topic 3: Query Flexibility — MQL Aggregation Pipeline vs. CQL Constraints

MongoDB's **aggregation pipeline** is one of its most powerful features. It allows developers to chain stages (`$match`, `$group`, `$unwind`, `$sort`, `$project`, `$lookup`) to transform and analyze data in arbitrarily complex ways — all without moving data out of the database. For example, this assignment's revenue-by-category query unwinds embedded items, groups by category, and computes totals in a single pipeline expression. MQL supports ad hoc queries, secondary index scans, and full-text search, making it highly flexible for exploratory analytics.

Cassandra's **CQL** operates under a strict **one table per query** constraint. Every query must specify the full partition key, and range predicates are only allowed on clustering columns. There are no joins, no subqueries, and no `GROUP BY` aggregations in the relational sense. **Access patterns must be known at schema design time.** This is not a limitation to work around — it is a deliberate design choice that allows Cassandra to guarantee single-partition reads, which are O(1) regardless of cluster size.

The consequence is clear: MongoDB is better suited for analytics-heavy workloads with complex, changing queries, while Cassandra excels at high-volume, simple, predictable read/write patterns.

---

## Topic 4: Write and Read Performance — WiredTiger vs. SSTable/Memtable

MongoDB uses the **WiredTiger** storage engine, which is based on a **B-tree** data structure. Writes update the B-tree in place (after journaling for crash recovery), and reads walk the tree to find matching documents. WiredTiger supports compression and document-level concurrency control, making it efficient for mixed read/write workloads. However, random writes on large datasets can cause B-tree splits and page fragmentation over time.

Cassandra uses a **Log-Structured Merge (LSM) tree** architecture. All writes first go to an in-memory structure called a **memtable** and are also appended to a commit log for durability. When the memtable fills, it is flushed to disk as an immutable **SSTable** (Sorted String Table). Reads must check the memtable and potentially multiple SSTables, using bloom filters to minimize disk I/O. Periodic **compaction** merges SSTables to reduce read amplification and reclaim space.

This means Cassandra's **write path** is extremely fast — sequential disk appends are much faster than random B-tree updates — making it ideal for write-heavy workloads like click streams and event logs. MongoDB's write performance is competitive for moderate loads but may degrade under extreme write pressure without careful indexing and hardware tuning.

---

## Topic 5: When to Choose Each Database

### Choose MongoDB when:
- Your application requires flexible, evolving schemas where document structure may change over time
- You need complex, ad hoc queries and rich aggregation across multiple dimensions
- Your data has natural hierarchical relationships (orders with embedded items, blog posts with embedded comments)
- You are building analytics dashboards, content management systems, or product catalogs where query patterns are not fully known in advance
- MongoDB works well for applications that prioritize developer productivity and query expressiveness over raw write throughput

### Choose Cassandra when:
- Your application generates massive write volumes that must be ingested with low, predictable latency — think IoT sensor data, user activity streams, or financial transaction logs
- You need geographic distribution across multiple data centers with tunable, per-operation consistency
- Your access patterns are well-defined and unlikely to change (e.g., always query by user ID and date)
- Cassandra works well for time-series data, leaderboards, recommendation engines, and any workload where horizontal scalability and write performance are the primary requirements
- You need the system to remain available during partial network failures (AP positioning)

---

## Summary

| Dimension | MongoDB | Cassandra |
|---|---|---|
| Schema style | Entity-centric, flexible | Query-centric, denormalized |
| CAP positioning | CP | AP |
| Query model | Rich MQL + aggregation pipeline | CQL, partition-key-only |
| Write path | WiredTiger B-tree | LSM (memtable → SSTable) |
| Best for | Analytics, flexible schemas | High-volume writes, time-series |

Both databases are powerful tools that solve real problems. The key is matching the database's strengths to the application's access patterns and consistency requirements.
