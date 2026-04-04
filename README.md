# CS 6500 Assignment 3: NoSQL

## Overview
This repository contains solutions for Assignment 3, covering MongoDB (document store) and Cassandra (wide-column store) for an e-commerce analytics scenario.

## Prerequisites

Start the Docker stack:

```bash
cd docker
docker compose up -d
```

Verify services are running:

```bash
docker compose ps   # mongodb and cassandra should be "Up"
```

---

## Part 1: MongoDB

Run the setup and query script:

```bash
docker exec -i mongodb mongosh \
  -u admin -p bigdata123 --authenticationDatabase admin \
  --quiet mongodb://localhost:27017/ecommerce --file mongo/commands.js
```

Interactive shell:

```bash
docker exec -it mongodb mongosh -u admin -p bigdata123 --authenticationDatabase admin ecommerce
```

Run autograder tests locally:

```bash
export MONGO_URI="mongodb://admin:bigdata123@localhost:27017/?authSource=admin"
pytest tests/ -v
```

---

## Part 2: Cassandra

Wait ~2 minutes after `docker compose up` for Cassandra to become ready. Verify:

```bash
docker exec cassandra cqlsh -e "DESCRIBE keyspaces"
```

Create keyspace and tables:

```bash
docker exec -i cassandra cqlsh < cassandra/schema.cql
```

Load data and run queries:

```bash
docker exec -i cassandra cqlsh < cassandra/queries.cql
```

Interactive shell:

```bash
docker exec -it cassandra cqlsh
```

---

## Submission

Push completed work to the `main` branch before the deadline. Automated tests run on every push — check the **Actions** tab to monitor test results and score.
