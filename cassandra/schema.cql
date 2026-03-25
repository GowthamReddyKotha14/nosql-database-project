-- Assignment 3 — Part 2: Cassandra Schema
-- Run with: cqlsh -f cassandra/schema.cql
--
-- Do not rename the keyspace or tables — the autograder expects:
--   keyspace:  ecommerce
--   tables:    orders_by_user_date, revenue_by_category_date, clicks_by_user

-- ─── Keyspace ─────────────────────────────────────────────────────────────────
-- TODO: create the keyspace with SimpleStrategy and replication_factor = 3.
-- DROP KEYSPACE IF EXISTS ecommerce;
-- CREATE KEYSPACE ...

USE ecommerce;

-- ─── Table 1: orders_by_user_date ─────────────────────────────────────────────
-- Must support: "get all orders for a specific user on a specific date,
--               returned newest first — no ALLOW FILTERING"
-- TODO: design the PRIMARY KEY and write the CREATE TABLE statement.
-- CREATE TABLE orders_by_user_date ( ... );

-- ─── Table 2: revenue_by_category_date ───────────────────────────────────────
-- Must support: "total revenue for a given product category on a given date —
--               no ALLOW FILTERING"
-- TODO: design the PRIMARY KEY and write the CREATE TABLE statement.
-- CREATE TABLE revenue_by_category_date ( ... );

-- ─── Table 3: clicks_by_user ──────────────────────────────────────────────────
-- Must support: "the last N click events for a specific user —
--               no ALLOW FILTERING"
-- TODO: design the PRIMARY KEY and write the CREATE TABLE statement.
-- CREATE TABLE clicks_by_user ( ... );
