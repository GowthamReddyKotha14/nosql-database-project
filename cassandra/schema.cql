-- cassandra/schema.cql
-- CS 6500 Assignment 3 — Cassandra Schema
-- Run: docker exec -i cassandra cqlsh < cassandra/schema.cql

-- Drop and recreate keyspace
DROP KEYSPACE IF EXISTS ecommerce;

CREATE KEYSPACE ecommerce
  WITH replication = {
    'class': 'SimpleStrategy',
    'replication_factor': 3
  };

USE ecommerce;

-- Table 1: Orders by user and date
-- Query pattern: "Get orders for a specific user on a specific date"
-- Composite partition key: (user_id, order_date)
-- Clustering column: order_ts (for ordering within partition)
CREATE TABLE orders_by_user_date (
  user_id    TEXT,
  order_date DATE,
  order_ts   TIMESTAMP,
  order_id   TEXT,
  status     TEXT,
  total      DECIMAL,
  items      TEXT,
  PRIMARY KEY ((user_id, order_date), order_ts)
) WITH CLUSTERING ORDER BY (order_ts DESC);

-- Table 2: Revenue by category and date
-- Query pattern: "Get revenue for a category on a specific date"
-- Composite partition key: (category, order_date)
CREATE TABLE revenue_by_category_date (
  category    TEXT,
  order_date  DATE,
  order_id    TEXT,
  product_id  TEXT,
  quantity    INT,
  unit_price  DECIMAL,
  revenue     DECIMAL,
  PRIMARY KEY ((category, order_date), order_id, product_id)
);

-- Table 3: Clicks by user
-- Query pattern: "Get last N clicks for a user"
-- Partition key: user_id
-- Clustering column: click_ts (descending for last-N queries)
CREATE TABLE clicks_by_user (
  user_id    TEXT,
  click_ts   TIMESTAMP,
  product_id TEXT,
  page       TEXT,
  PRIMARY KEY (user_id, click_ts)
) WITH CLUSTERING ORDER BY (click_ts DESC);
