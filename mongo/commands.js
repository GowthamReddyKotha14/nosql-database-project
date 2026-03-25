// Assignment 3 — Part 1: MongoDB Document Modeling & Aggregation
// Run with: mongosh --quiet "mongodb://localhost:27017/ecommerce" --file mongo/commands.js
//
// Do not rename collections — the autograder expects: orders, products, users, clicks.
// Starter data is preloaded below so students can focus on queries/aggregations.

// Ensure script targets the expected database in --file mode.
db = db.getSiblingDB("ecommerce");

// ─── 1. Insert sample products (provided) ─────────────────────────────────────
db.products.drop();
db.products.insertMany([
  { product_id: "PROD_001", name: "Wireless Headphones", category: "Electronics", price: 79.99 },
  { product_id: "PROD_002", name: "Running Shoes", category: "Clothing", price: 89.99 },
  { product_id: "PROD_003", name: "Coffee Maker", category: "Home & Kitchen", price: 129.99 },
  { product_id: "PROD_004", name: "Yoga Mat", category: "Sports", price: 29.99 },
  { product_id: "PROD_005", name: "Smart Watch", category: "Electronics", price: 199.99 },
  { product_id: "PROD_006", name: "Desk Lamp", category: "Home & Kitchen", price: 34.99 },
  { product_id: "PROD_007", name: "Laptop Backpack", category: "Clothing", price: 49.99 },
  { product_id: "PROD_008", name: "Bluetooth Speaker", category: "Electronics", price: 59.99 }
]);

// ─── 2. Insert sample users (provided) ────────────────────────────────────────
db.users.drop();
db.users.insertMany([
  { user_id: "USER_001", name: "Alice Johnson", email: "alice@example.com" },
  { user_id: "USER_002", name: "Bob Smith", email: "bob@example.com" },
  { user_id: "USER_003", name: "Carol White", email: "carol@example.com" },
  { user_id: "USER_004", name: "David Lee", email: "david@example.com" },
  { user_id: "USER_005", name: "Emma Davis", email: "emma@example.com" }
]);

// ─── 3. Insert orders with embedded line items (provided) ────────────────────
db.orders.drop();
db.orders.insertMany([
  {
    order_id: "ORD_001",
    user_id: "USER_001",
    order_date: new Date("2024-01-15"),
    order_ts: new Date("2024-01-15T10:30:00Z"),
    status: "completed",
    items: [
      { product_id: "PROD_001", name: "Wireless Headphones", category: "Electronics", quantity: 1, price: 79.99 },
      { product_id: "PROD_004", name: "Yoga Mat", category: "Sports", quantity: 2, price: 29.99 }
    ],
    total: 139.97
  },
  {
    order_id: "ORD_002",
    user_id: "USER_002",
    order_date: new Date("2024-01-16"),
    order_ts: new Date("2024-01-16T14:20:00Z"),
    status: "completed",
    items: [
      { product_id: "PROD_005", name: "Smart Watch", category: "Electronics", quantity: 1, price: 199.99 }
    ],
    total: 199.99
  },
  {
    order_id: "ORD_003",
    user_id: "USER_001",
    order_date: new Date("2024-01-18"),
    order_ts: new Date("2024-01-18T09:15:00Z"),
    status: "shipped",
    items: [
      { product_id: "PROD_003", name: "Coffee Maker", category: "Home & Kitchen", quantity: 1, price: 129.99 },
      { product_id: "PROD_006", name: "Desk Lamp", category: "Home & Kitchen", quantity: 1, price: 34.99 }
    ],
    total: 164.98
  },
  {
    order_id: "ORD_004",
    user_id: "USER_003",
    order_date: new Date("2024-01-18"),
    order_ts: new Date("2024-01-18T16:45:00Z"),
    status: "completed",
    items: [
      { product_id: "PROD_002", name: "Running Shoes", category: "Clothing", quantity: 1, price: 89.99 },
      { product_id: "PROD_007", name: "Laptop Backpack", category: "Clothing", quantity: 1, price: 49.99 }
    ],
    total: 139.98
  },
  {
    order_id: "ORD_005",
    user_id: "USER_004",
    order_date: new Date("2024-01-20"),
    order_ts: new Date("2024-01-20T11:00:00Z"),
    status: "completed",
    items: [
      { product_id: "PROD_008", name: "Bluetooth Speaker", category: "Electronics", quantity: 2, price: 59.99 }
    ],
    total: 119.98
  },
  {
    order_id: "ORD_006",
    user_id: "USER_001",
    order_date: new Date("2024-01-22"),
    order_ts: new Date("2024-01-22T13:30:00Z"),
    status: "pending",
    items: [
      { product_id: "PROD_004", name: "Yoga Mat", category: "Sports", quantity: 1, price: 29.99 }
    ],
    total: 29.99
  }
]);

// ─── 4. Insert sample clicks (provided) ──────────────────────────────────────
db.clicks.drop();
db.clicks.insertMany([
  { user_id: "USER_001", ts: new Date("2024-01-15T10:00:00Z"), action: "view", product_id: "PROD_001" },
  { user_id: "USER_001", ts: new Date("2024-01-15T10:05:00Z"), action: "add_to_cart", product_id: "PROD_001" },
  { user_id: "USER_001", ts: new Date("2024-01-15T10:10:00Z"), action: "view", product_id: "PROD_004" },
  { user_id: "USER_001", ts: new Date("2024-01-15T10:15:00Z"), action: "add_to_cart", product_id: "PROD_004" },
  { user_id: "USER_001", ts: new Date("2024-01-15T10:30:00Z"), action: "purchase", product_id: null },
  { user_id: "USER_001", ts: new Date("2024-01-18T09:00:00Z"), action: "view", product_id: "PROD_003" },
  { user_id: "USER_001", ts: new Date("2024-01-18T09:05:00Z"), action: "view", product_id: "PROD_006" },
  { user_id: "USER_001", ts: new Date("2024-01-18T09:10:00Z"), action: "add_to_cart", product_id: "PROD_003" },
  { user_id: "USER_001", ts: new Date("2024-01-18T09:12:00Z"), action: "add_to_cart", product_id: "PROD_006" },
  { user_id: "USER_001", ts: new Date("2024-01-18T09:15:00Z"), action: "purchase", product_id: null },
  { user_id: "USER_002", ts: new Date("2024-01-16T14:00:00Z"), action: "view", product_id: "PROD_005" },
  { user_id: "USER_002", ts: new Date("2024-01-16T14:10:00Z"), action: "add_to_cart", product_id: "PROD_005" },
  { user_id: "USER_002", ts: new Date("2024-01-16T14:20:00Z"), action: "purchase", product_id: null },
  { user_id: "USER_003", ts: new Date("2024-01-18T16:30:00Z"), action: "view", product_id: "PROD_002" },
  { user_id: "USER_003", ts: new Date("2024-01-18T16:35:00Z"), action: "view", product_id: "PROD_007" }
]);

// ─── 5. Aggregation: total revenue by category and day ────────────────────────
// TODO: write an aggregation pipeline that returns total revenue and order count
// per product category per day.
// Expected output fields: category, date, total_revenue, order_count
print("\n--- Aggregation 1: Revenue by category and day ---");
// YOUR CODE HERE

// ─── 6. Aggregation: top 5 products by revenue per category ───────────────────
// TODO: write an aggregation pipeline that returns the top 5 products by revenue
// within each category.
print("\n--- Aggregation 2: Top 5 products per category ---");
// YOUR CODE HERE

// ─── 7. Query: last 10 clicks for USER_001 ────────────────────────────────────
// TODO: write a find() query that returns the 10 most recent clicks for USER_001.
print("\n--- Query: Last 10 clicks for USER_001 ---");
// YOUR CODE HERE

// ─── 8. Create indexes (provided baseline) ───────────────────────────────────
// Baseline indexes are pre-created so students can focus on query logic.
print("\n--- Creating baseline indexes ---");
db.orders.createIndex({ user_id: 1, order_date: -1 });
db.orders.createIndex({ order_date: 1 });
db.clicks.createIndex({ user_id: 1, ts: -1 });

print("\n--- Index information ---");
printjson(db.orders.getIndexes());
printjson(db.clicks.getIndexes());
