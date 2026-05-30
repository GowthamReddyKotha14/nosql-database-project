# NoSQL E-Commerce Analytics Platform

## Overview

This project explores the design and implementation of scalable NoSQL database solutions for an e-commerce analytics workload using MongoDB and Apache Cassandra.

##Key contributions include:

Designing document-based schemas in MongoDB
Designing wide-column schemas in Cassandra
Implementing analytical and aggregation queries
Evaluating performance and scalability trade-offs
Demonstrating consistency and data-modeling strategies across NoSQL paradigms

Technologies: MongoDB, Cassandra, Docker, JavaScript, CQL, Python Testing

## Repository Structure

```
├── mongo/
│   ├── commands.js             ← complete this (MongoDB operations)
│   └── sample_outputs.json     ← complete this (query results + explain output)
├── cassandra/
│   ├── schema.cql              ← complete this (keyspace + table DDL)
│   └── queries.cql             ← complete this (inserts, queries, consistency demo)
├── analysis/
│   └── tradeoffs.md            ← complete this (2–3 page comparative analysis)
├── README.md                   ← update the "How to Run" section below
└── DESIGN_RATIONALE.md         ← complete this (design decisions + AI use)
```

## How to Run

### Prerequisites

Start the Docker stack from your course materials:

```
cd docker
docker compose up -d
```

Verify the services:

```
docker compose ps   # mongodb and cassandra should be "Up"
```

### Part 1: MongoDB

Starter data is embedded directly in `mongo/commands.js`. Run this from the root of your assignment repo:

```
# Run setup data + your query/aggregation work in one script
docker exec -i mongodb mongosh \
  -u admin -p bigdata123 --authenticationDatabase admin \
  --quiet mongodb://localhost:27017/ecommerce --file mongo/commands.js
```

**Tip — interactive shell:** `docker exec -it mongodb mongosh -u admin -p bigdata123 --authenticationDatabase admin ecommerce`

Running the autograder tests locally requires telling pytest how to authenticate:

```
export MONGO_URI="mongodb://admin:bigdata123@localhost:27017/?authSource=admin"
pytest tests/ -v
```

### Part 2: Cassandra

Cassandra takes ~2 minutes to become ready after `docker compose up`. Wait until this returns output before running CQL:

```
docker exec cassandra cqlsh -e "DESCRIBE keyspaces"
```

Then pipe your `.cql` files into the container's `cqlsh` directly — no `docker cp` needed:

```
# Step 1: create keyspace and tables
docker exec -i cassandra cqlsh < cassandra/schema.cql

# Step 2: load provided sample data and run your queries
docker exec -i cassandra cqlsh < cassandra/queries.cql
```

**Tip — interactive shell:** `docker exec -it cassandra cqlsh`

## Submission

Push your completed work to the `main` branch before the deadline. That's it — no separate submission step is required.

Automated tests run on every push. Check the **Actions** tab in your repository to see which tests are passing and your current score.
