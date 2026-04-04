-- cassandra/queries.cql
-- CS 6500 Assignment 3 — Cassandra Inserts, Queries, and Consistency Demo
-- Run: docker exec -i cassandra cqlsh < cassandra/queries.cql

USE ecommerce;

-- ─── INSERT: orders_by_user_date (≥10 rows) ──────────────────────────────────
INSERT INTO orders_by_user_date (user_id, order_date, order_ts, order_id, status, total, items)
VALUES ('u1', '2026-01-15', '2026-01-15 10:00:00+0000', 'o1', 'delivered', 1359.97, '[{"product_id":"p1","qty":1,"price":1299.99},{"product_id":"p2","qty":2,"price":29.99}]');

INSERT INTO orders_by_user_date (user_id, order_date, order_ts, order_id, status, total, items)
VALUES ('u2', '2026-01-16', '2026-01-16 11:00:00+0000', 'o2', 'delivered', 399.98, '[{"product_id":"p3","qty":1,"price":349.99},{"product_id":"p8","qty":1,"price":49.99}]');

INSERT INTO orders_by_user_date (user_id, order_date, order_ts, order_id, status, total, items)
VALUES ('u3', '2026-01-17', '2026-01-17 12:00:00+0000', 'o3', 'shipped', 159.97, '[{"product_id":"p5","qty":2,"price":49.99},{"product_id":"p6","qty":1,"price":59.99}]');

INSERT INTO orders_by_user_date (user_id, order_date, order_ts, order_id, status, total, items)
VALUES ('u4', '2026-01-18', '2026-01-18 13:00:00+0000', 'o4', 'delivered', 289.98, '[{"product_id":"p7","qty":1,"price":199.99},{"product_id":"p9","qty":1,"price":89.99}]');

INSERT INTO orders_by_user_date (user_id, order_date, order_ts, order_id, status, total, items)
VALUES ('u5', '2026-01-19', '2026-01-19 14:00:00+0000', 'o5', 'delivered', 599.99, '[{"product_id":"p4","qty":1,"price":599.99}]');

INSERT INTO orders_by_user_date (user_id, order_date, order_ts, order_id, status, total, items)
VALUES ('u1', '2026-02-01', '2026-02-01 10:00:00+0000', 'o6', 'delivered', 184.96, '[{"product_id":"p10","qty":3,"price":44.99},{"product_id":"p5","qty":1,"price":49.99}]');

INSERT INTO orders_by_user_date (user_id, order_date, order_ts, order_id, status, total, items)
VALUES ('u2', '2026-02-03', '2026-02-03 11:00:00+0000', 'o7', 'shipped', 1699.97, '[{"product_id":"p1","qty":1,"price":1299.99},{"product_id":"p7","qty":2,"price":199.99}]');

INSERT INTO orders_by_user_date (user_id, order_date, order_ts, order_id, status, total, items)
VALUES ('u3', '2026-02-05', '2026-02-05 12:00:00+0000', 'o8', 'delivered', 1299.97, '[{"product_id":"p3","qty":2,"price":349.99},{"product_id":"p4","qty":1,"price":599.99}]');

INSERT INTO orders_by_user_date (user_id, order_date, order_ts, order_id, status, total, items)
VALUES ('u4', '2026-02-10', '2026-02-10 13:00:00+0000', 'o9', 'delivered', 329.83, '[{"product_id":"p2","qty":5,"price":29.99},{"product_id":"p9","qty":2,"price":89.99}]');

INSERT INTO orders_by_user_date (user_id, order_date, order_ts, order_id, status, total, items)
VALUES ('u5', '2026-02-14', '2026-02-14 14:00:00+0000', 'o10', 'shipped', 164.97, '[{"product_id":"p6","qty":2,"price":59.99},{"product_id":"p10","qty":1,"price":44.99}]');

-- ─── INSERT: revenue_by_category_date (≥10 rows) ────────────────────────────
INSERT INTO revenue_by_category_date (category, order_date, order_id, product_id, quantity, unit_price, revenue)
VALUES ('Electronics', '2026-01-15', 'o1', 'p1', 1, 1299.99, 1299.99);

INSERT INTO revenue_by_category_date (category, order_date, order_id, product_id, quantity, unit_price, revenue)
VALUES ('Electronics', '2026-01-15', 'o1', 'p2', 2, 29.99, 59.98);

INSERT INTO revenue_by_category_date (category, order_date, order_id, product_id, quantity, unit_price, revenue)
VALUES ('Furniture', '2026-01-16', 'o2', 'p3', 1, 349.99, 349.99);

INSERT INTO revenue_by_category_date (category, order_date, order_id, product_id, quantity, unit_price, revenue)
VALUES ('Furniture', '2026-01-16', 'o2', 'p8', 1, 49.99, 49.99);

INSERT INTO revenue_by_category_date (category, order_date, order_id, product_id, quantity, unit_price, revenue)
VALUES ('Books', '2026-01-17', 'o3', 'p5', 2, 49.99, 99.98);

INSERT INTO revenue_by_category_date (category, order_date, order_id, product_id, quantity, unit_price, revenue)
VALUES ('Books', '2026-01-17', 'o3', 'p6', 1, 59.99, 59.99);

INSERT INTO revenue_by_category_date (category, order_date, order_id, product_id, quantity, unit_price, revenue)
VALUES ('Electronics', '2026-01-18', 'o4', 'p7', 1, 199.99, 199.99);

INSERT INTO revenue_by_category_date (category, order_date, order_id, product_id, quantity, unit_price, revenue)
VALUES ('Electronics', '2026-01-18', 'o4', 'p9', 1, 89.99, 89.99);

INSERT INTO revenue_by_category_date (category, order_date, order_id, product_id, quantity, unit_price, revenue)
VALUES ('Furniture', '2026-01-19', 'o5', 'p4', 1, 599.99, 599.99);

INSERT INTO revenue_by_category_date (category, order_date, order_id, product_id, quantity, unit_price, revenue)
VALUES ('Books', '2026-02-01', 'o6', 'p10', 3, 44.99, 134.97);

INSERT INTO revenue_by_category_date (category, order_date, order_id, product_id, quantity, unit_price, revenue)
VALUES ('Books', '2026-02-01', 'o6', 'p5', 1, 49.99, 49.99);

INSERT INTO revenue_by_category_date (category, order_date, order_id, product_id, quantity, unit_price, revenue)
VALUES ('Electronics', '2026-02-03', 'o7', 'p1', 1, 1299.99, 1299.99);

-- ─── INSERT: clicks_by_user (≥10 rows) ───────────────────────────────────────
INSERT INTO clicks_by_user (user_id, click_ts, product_id, page)
VALUES ('u1', '2026-01-15 10:00:00+0000', 'p1', 'product');

INSERT INTO clicks_by_user (user_id, click_ts, product_id, page)
VALUES ('u1', '2026-01-15 10:05:00+0000', 'p2', 'product');

INSERT INTO clicks_by_user (user_id, click_ts, product_id, page)
VALUES ('u1', '2026-01-15 10:10:00+0000', 'p7', 'product');

INSERT INTO clicks_by_user (user_id, click_ts, product_id, page)
VALUES ('u1', '2026-01-16 09:00:00+0000', 'p3', 'product');

INSERT INTO clicks_by_user (user_id, click_ts, product_id, page)
VALUES ('u2', '2026-01-16 11:00:00+0000', 'p1', 'product');

INSERT INTO clicks_by_user (user_id, click_ts, product_id, page)
VALUES ('u2', '2026-01-17 12:00:00+0000', 'p4', 'product');

INSERT INTO clicks_by_user (user_id, click_ts, product_id, page)
VALUES ('u3', '2026-01-17 13:00:00+0000', 'p5', 'product');

INSERT INTO clicks_by_user (user_id, click_ts, product_id, page)
VALUES ('u3', '2026-01-18 14:00:00+0000', 'p6', 'product');

INSERT INTO clicks_by_user (user_id, click_ts, product_id, page)
VALUES ('u4', '2026-01-18 15:00:00+0000', 'p9', 'product');

INSERT INTO clicks_by_user (user_id, click_ts, product_id, page)
VALUES ('u5', '2026-01-19 16:00:00+0000', 'p4', 'product');

INSERT INTO clicks_by_user (user_id, click_ts, product_id, page)
VALUES ('u1', '2026-02-01 10:00:00+0000', 'p9', 'product');

INSERT INTO clicks_by_user (user_id, click_ts, product_id, page)
VALUES ('u2', '2026-02-03 11:00:00+0000', 'p7', 'product');

-- ─── QUERIES ──────────────────────────────────────────────────────────────────

-- Query 1: Get orders for a specific user on a specific date
SELECT * FROM ecommerce.orders_by_user_date
WHERE user_id = 'u1' AND order_date = '2026-01-15';

-- Query 2: Get revenue for Electronics on a specific date
SELECT * FROM ecommerce.revenue_by_category_date
WHERE category = 'Electronics' AND order_date = '2026-01-15';

-- Query 3: Last 10 clicks for user u1
SELECT * FROM ecommerce.clicks_by_user
WHERE user_id = 'u1'
LIMIT 10;

-- ─── CONSISTENCY LEVEL DEMO ──────────────────────────────────────────────────

-- CONSISTENCY QUORUM ensures a majority of replicas agree before returning
-- This provides strong consistency at the cost of slightly higher latency
CONSISTENCY QUORUM;

SELECT * FROM ecommerce.orders_by_user_date
WHERE user_id = 'u1' AND order_date = '2026-01-15';

-- CONSISTENCY ONE is faster but may return stale data
CONSISTENCY ONE;

SELECT * FROM ecommerce.clicks_by_user
WHERE user_id = 'u1'
LIMIT 10;
