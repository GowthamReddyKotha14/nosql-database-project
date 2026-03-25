-- Assignment 3 — Part 2: Cassandra Queries
-- Run with: cqlsh -f cassandra/queries.cql  (after schema.cql has been loaded)
--
-- Starter inserts are preloaded below so students can focus on query writing.

USE ecommerce;

-- ─── Inserts: orders_by_user_date (minimum 10 rows) ──────────────────────────
INSERT INTO orders_by_user_date (user_id, order_date, order_ts, order_id, total, status, items_summary)
VALUES ('USER_001', '2024-01-15', '2024-01-15 10:30:00+0000', 'ORD_001', 139.97, 'completed',
	'[{"product_id":"PROD_001","name":"Wireless Headphones","quantity":1,"price":79.99},{"product_id":"PROD_004","name":"Yoga Mat","quantity":2,"price":29.99}]');

INSERT INTO orders_by_user_date (user_id, order_date, order_ts, order_id, total, status, items_summary)
VALUES ('USER_001', '2024-01-15', '2024-01-15 16:00:00+0000', 'ORD_008', 49.99, 'completed',
	'[{"product_id":"PROD_007","name":"Laptop Backpack","quantity":1,"price":49.99}]');

INSERT INTO orders_by_user_date (user_id, order_date, order_ts, order_id, total, status, items_summary)
VALUES ('USER_001', '2024-01-18', '2024-01-18 09:15:00+0000', 'ORD_003', 164.98, 'shipped',
	'[{"product_id":"PROD_003","name":"Coffee Maker","quantity":1,"price":129.99},{"product_id":"PROD_006","name":"Desk Lamp","quantity":1,"price":34.99}]');

INSERT INTO orders_by_user_date (user_id, order_date, order_ts, order_id, total, status, items_summary)
VALUES ('USER_001', '2024-01-22', '2024-01-22 13:30:00+0000', 'ORD_006', 29.99, 'pending',
	'[{"product_id":"PROD_004","name":"Yoga Mat","quantity":1,"price":29.99}]');

INSERT INTO orders_by_user_date (user_id, order_date, order_ts, order_id, total, status, items_summary)
VALUES ('USER_002', '2024-01-16', '2024-01-16 14:20:00+0000', 'ORD_002', 199.99, 'completed',
	'[{"product_id":"PROD_005","name":"Smart Watch","quantity":1,"price":199.99}]');

INSERT INTO orders_by_user_date (user_id, order_date, order_ts, order_id, total, status, items_summary)
VALUES ('USER_002', '2024-01-20', '2024-01-20 15:45:00+0000', 'ORD_007', 79.99, 'completed',
	'[{"product_id":"PROD_001","name":"Wireless Headphones","quantity":1,"price":79.99}]');

INSERT INTO orders_by_user_date (user_id, order_date, order_ts, order_id, total, status, items_summary)
VALUES ('USER_003', '2024-01-18', '2024-01-18 16:45:00+0000', 'ORD_004', 139.98, 'completed',
	'[{"product_id":"PROD_002","name":"Running Shoes","quantity":1,"price":89.99},{"product_id":"PROD_007","name":"Laptop Backpack","quantity":1,"price":49.99}]');

INSERT INTO orders_by_user_date (user_id, order_date, order_ts, order_id, total, status, items_summary)
VALUES ('USER_003', '2024-01-22', '2024-01-22 10:00:00+0000', 'ORD_009', 219.97, 'shipped',
	'[{"product_id":"PROD_005","name":"Smart Watch","quantity":1,"price":199.99},{"product_id":"PROD_004","name":"Yoga Mat","quantity":1,"price":29.99}]');

INSERT INTO orders_by_user_date (user_id, order_date, order_ts, order_id, total, status, items_summary)
VALUES ('USER_004', '2024-01-20', '2024-01-20 11:00:00+0000', 'ORD_005', 119.98, 'completed',
	'[{"product_id":"PROD_008","name":"Bluetooth Speaker","quantity":2,"price":59.99}]');

INSERT INTO orders_by_user_date (user_id, order_date, order_ts, order_id, total, status, items_summary)
VALUES ('USER_005', '2024-01-19', '2024-01-19 12:30:00+0000', 'ORD_010', 89.99, 'completed',
	'[{"product_id":"PROD_002","name":"Running Shoes","quantity":1,"price":89.99}]');

-- ─── Inserts: revenue_by_category_date (minimum 10 rows) ─────────────────────
INSERT INTO revenue_by_category_date (category, order_date, total_revenue, order_count)
VALUES ('Electronics', '2024-01-15', 279.96, 2);

INSERT INTO revenue_by_category_date (category, order_date, total_revenue, order_count)
VALUES ('Sports', '2024-01-15', 89.97, 3);

INSERT INTO revenue_by_category_date (category, order_date, total_revenue, order_count)
VALUES ('Clothing', '2024-01-15', 49.99, 1);

INSERT INTO revenue_by_category_date (category, order_date, total_revenue, order_count)
VALUES ('Electronics', '2024-01-16', 199.99, 1);

INSERT INTO revenue_by_category_date (category, order_date, total_revenue, order_count)
VALUES ('Home & Kitchen', '2024-01-18', 164.98, 2);

INSERT INTO revenue_by_category_date (category, order_date, total_revenue, order_count)
VALUES ('Clothing', '2024-01-18', 139.98, 2);

INSERT INTO revenue_by_category_date (category, order_date, total_revenue, order_count)
VALUES ('Clothing', '2024-01-19', 89.99, 1);

INSERT INTO revenue_by_category_date (category, order_date, total_revenue, order_count)
VALUES ('Electronics', '2024-01-20', 199.97, 2);

INSERT INTO revenue_by_category_date (category, order_date, total_revenue, order_count)
VALUES ('Electronics', '2024-01-22', 199.99, 1);

INSERT INTO revenue_by_category_date (category, order_date, total_revenue, order_count)
VALUES ('Sports', '2024-01-22', 59.98, 2);

-- ─── Inserts: clicks_by_user (minimum 10 rows) ───────────────────────────────
INSERT INTO clicks_by_user (user_id, click_ts, action, product_id)
VALUES ('USER_001', '2024-01-15 10:00:00+0000', 'view',        'PROD_001');

INSERT INTO clicks_by_user (user_id, click_ts, action, product_id)
VALUES ('USER_001', '2024-01-15 10:05:00+0000', 'add_to_cart', 'PROD_001');

INSERT INTO clicks_by_user (user_id, click_ts, action, product_id)
VALUES ('USER_001', '2024-01-15 10:10:00+0000', 'view',        'PROD_004');

INSERT INTO clicks_by_user (user_id, click_ts, action, product_id)
VALUES ('USER_001', '2024-01-15 10:15:00+0000', 'add_to_cart', 'PROD_004');

INSERT INTO clicks_by_user (user_id, click_ts, action, product_id)
VALUES ('USER_001', '2024-01-15 10:30:00+0000', 'purchase',    null);

INSERT INTO clicks_by_user (user_id, click_ts, action, product_id)
VALUES ('USER_001', '2024-01-18 09:00:00+0000', 'view',        'PROD_003');

INSERT INTO clicks_by_user (user_id, click_ts, action, product_id)
VALUES ('USER_001', '2024-01-18 09:05:00+0000', 'view',        'PROD_006');

INSERT INTO clicks_by_user (user_id, click_ts, action, product_id)
VALUES ('USER_001', '2024-01-18 09:10:00+0000', 'add_to_cart', 'PROD_003');

INSERT INTO clicks_by_user (user_id, click_ts, action, product_id)
VALUES ('USER_001', '2024-01-18 09:12:00+0000', 'add_to_cart', 'PROD_006');

INSERT INTO clicks_by_user (user_id, click_ts, action, product_id)
VALUES ('USER_001', '2024-01-18 09:15:00+0000', 'purchase',    null);

-- ─── Query 1: Orders for USER_001 on 2024-01-15, newest first ────────────────
-- TODO: write the SELECT statement. Must hit the partition key exactly.
-- No ALLOW FILTERING.
-- SELECT ...

-- ─── Query 2: Electronics revenue 2024-01-15 → 2024-01-22 ───────────────────
-- TODO: write the SELECT statement. No ALLOW FILTERING.
-- SELECT ...

-- ─── Query 3: Last 10 clicks for USER_001 ────────────────────────────────────
-- TODO: query clicks_by_user with LIMIT 10. No ALLOW FILTERING.
-- SELECT ...

-- ─── Consistency Level Demonstration ─────────────────────────────────────────
-- TODO: set CONSISTENCY QUORUM, then run one INSERT and one SELECT on
-- orders_by_user_date. After the statements, add a comment block explaining
-- what QUORUM means and why R + W > RF guarantees strong consistency.
--
-- NOTE (local Docker): this course stack runs a single Cassandra node.
-- With RF=3, QUORUM may raise "Cannot achieve consistency level QUORUM".
-- Keep your QUORUM explanation in comments, and if needed use ONE for local
-- execution so the script still runs end-to-end.

CONSISTENCY QUORUM;

-- INSERT ...  (same table as Query 1)
-- SELECT ...  (same table as Query 1)

-- EXPLANATION (replace this comment):
-- QUORUM requires ...
-- With RF=3, QUORUM means ...
-- R + W > RF guarantees strong consistency because ...
