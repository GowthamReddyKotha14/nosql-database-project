# Design Rationale — Assignment 3: NoSQL (Gowtham Kotha)

## MongoDB Schema Decisions

### Why embed items inside orders?
Order line items have no independent lifecycle — they are always created, read, and deleted together with their parent order. Embedding them as an array inside the order document avoids a separate collection join and allows the revenue aggregation pipeline to unwind and compute totals in a single query. This follows MongoDB's core guidance: embed what you own.

### Why use a scalar user_id reference instead of embedding the user?
Users exist independently of orders and are shared across many orders. Embedding the full user document inside every order would duplicate data and make user updates expensive (requiring updates to every embedded copy). A scalar `user_id` reference keeps the user document as a single source of truth.

### Why create a compound index on (user_id, order_date) and a separate index on order_date?
The revenue-by-category aggregation filters by order_date, so an index on order_date alone supports that pipeline efficiently. The compound index on (user_id, order_date) supports user-specific order lookups. The clicks collection uses a compound (user_id, ts) index to support the last-10-clicks query with a single efficient scan.

### Why include a clicks collection?
Click data is high-volume, time-series in nature, and queried by user in reverse chronological order. This is a distinct access pattern from orders and products, and separating it into its own collection with its own index keeps both collections performant.

---

## Cassandra Schema Decisions

### Why use a composite partition key (user_id, order_date) in orders_by_user_date?
Cassandra partitions data by the partition key across nodes. A single user_id partition could grow unboundedly over time, creating a "hot partition" problem. Including order_date in the partition key bounds each partition to a single user's orders on a single day, distributing data more evenly across the cluster while still supporting the primary access pattern.

### Why use order_ts as a clustering column?
Clustering columns define the physical sort order within a partition. Using order_ts as a clustering column with DESC ordering means Cassandra stores the most recent orders first on disk, making the "get latest orders" query a simple sequential read with no sorting overhead.

### Why duplicate data across orders_by_user_date and revenue_by_category_date?
Cassandra does not support joins. To serve two different queries — "orders by user and date" and "revenue by category and date" — two separate tables are required, each structured around its own partition key. This intentional denormalization is the standard Cassandra pattern and is a fundamental design requirement, not a mistake.

### Why use CONSISTENCY QUORUM for the order query?
In an e-commerce system, order data is financially sensitive. Using CONSISTENCY QUORUM ensures that a majority of replicas agree on the response before returning it to the client, preventing stale reads that could lead to incorrect inventory counts or duplicate order displays.

---

## AI Use Disclosure

I primarily used online resources and course materials to complete this assignment. For a few minor doubts and clarifications, I referred to general explanations available online. All design decisions, data modeling choices, and the written analysis are based on my own understanding of the material covered in Weeks 10 and 11.
