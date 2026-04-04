// mongo/commands.js
// CS 6500 Assignment 3 — MongoDB
// Run: docker exec -i mongodb mongosh -u admin -p bigdata123 --authenticationDatabase admin --quiet mongodb://localhost:27017/ecommerce --file mongo/commands.js

// ─── 1. DROP & RECREATE COLLECTIONS ────────────────────────────────────────
db.orders.drop();
db.products.drop();
db.users.drop();
db.clicks.drop();

// ─── 2. INSERT USERS ────────────────────────────────────────────────────────
db.users.insertMany([
  { _id: "u1", name: "Alice Johnson",  email: "alice@example.com",  region: "North" },
  { _id: "u2", name: "Bob Smith",      email: "bob@example.com",    region: "South" },
  { _id: "u3", name: "Carol White",    email: "carol@example.com",  region: "East"  },
  { _id: "u4", name: "David Brown",    email: "david@example.com",  region: "West"  },
  { _id: "u5", name: "Eva Martinez",   email: "eva@example.com",    region: "North" },
]);

// ─── 3. INSERT PRODUCTS ─────────────────────────────────────────────────────
db.products.insertMany([
  { _id: "p1",  name: "Laptop Pro",      category: "Electronics", price: 1299.99 },
  { _id: "p2",  name: "Wireless Mouse",  category: "Electronics", price: 29.99  },
  { _id: "p3",  name: "Office Chair",    category: "Furniture",   price: 349.99  },
  { _id: "p4",  name: "Standing Desk",   category: "Furniture",   price: 599.99  },
  { _id: "p5",  name: "Python Book",     category: "Books",       price: 49.99   },
  { _id: "p6",  name: "Data Science Book", category: "Books",     price: 59.99   },
  { _id: "p7",  name: "Headphones",      category: "Electronics", price: 199.99  },
  { _id: "p8",  name: "Desk Lamp",       category: "Furniture",   price: 49.99   },
  { _id: "p9",  name: "Keyboard",        category: "Electronics", price: 89.99   },
  { _id: "p10", name: "NoSQL Book",      category: "Books",       price: 44.99   },
]);

// ─── 4. INSERT ORDERS (with embedded items array) ───────────────────────────
db.orders.insertMany([
  {
    order_id: "o1", user_id: "u1",
    order_date: new Date("2026-01-15"),
    status: "delivered",
    items: [
      { product_id: "p1", category: "Electronics", quantity: 1, price: 1299.99 },
      { product_id: "p2", category: "Electronics", quantity: 2, price: 29.99  }
    ]
  },
  {
    order_id: "o2", user_id: "u2",
    order_date: new Date("2026-01-16"),
    status: "delivered",
    items: [
      { product_id: "p3", category: "Furniture", quantity: 1, price: 349.99 },
      { product_id: "p8", category: "Furniture", quantity: 1, price: 49.99  }
    ]
  },
  {
    order_id: "o3", user_id: "u3",
    order_date: new Date("2026-01-17"),
    status: "shipped",
    items: [
      { product_id: "p5", category: "Books", quantity: 2, price: 49.99 },
      { product_id: "p6", category: "Books", quantity: 1, price: 59.99 }
    ]
  },
  {
    order_id: "o4", user_id: "u4",
    order_date: new Date("2026-01-18"),
    status: "delivered",
    items: [
      { product_id: "p7", category: "Electronics", quantity: 1, price: 199.99 },
      { product_id: "p9", category: "Electronics", quantity: 1, price: 89.99  }
    ]
  },
  {
    order_id: "o5", user_id: "u5",
    order_date: new Date("2026-01-19"),
    status: "delivered",
    items: [
      { product_id: "p4", category: "Furniture", quantity: 1, price: 599.99 }
    ]
  },
  {
    order_id: "o6", user_id: "u1",
    order_date: new Date("2026-02-01"),
    status: "delivered",
    items: [
      { product_id: "p10", category: "Books", quantity: 3, price: 44.99 },
      { product_id: "p5",  category: "Books", quantity: 1, price: 49.99 }
    ]
  },
  {
    order_id: "o7", user_id: "u2",
    order_date: new Date("2026-02-03"),
    status: "shipped",
    items: [
      { product_id: "p1", category: "Electronics", quantity: 1, price: 1299.99 },
      { product_id: "p7", category: "Electronics", quantity: 2, price: 199.99  }
    ]
  },
  {
    order_id: "o8", user_id: "u3",
    order_date: new Date("2026-02-05"),
    status: "delivered",
    items: [
      { product_id: "p3", category: "Furniture", quantity: 2, price: 349.99 },
      { product_id: "p4", category: "Furniture", quantity: 1, price: 599.99 }
    ]
  },
  {
    order_id: "o9", user_id: "u4",
    order_date: new Date("2026-02-10"),
    status: "delivered",
    items: [
      { product_id: "p2", category: "Electronics", quantity: 5, price: 29.99 },
      { product_id: "p9", category: "Electronics", quantity: 2, price: 89.99 }
    ]
  },
  {
    order_id: "o10", user_id: "u5",
    order_date: new Date("2026-02-14"),
    status: "shipped",
    items: [
      { product_id: "p6",  category: "Books", quantity: 2, price: 59.99 },
      { product_id: "p10", category: "Books", quantity: 1, price: 44.99 }
    ]
  },
]);

// ─── 5. INSERT CLICKS ────────────────────────────────────────────────────────
db.clicks.insertMany([
  { user_id: "u1", product_id: "p1", ts: new Date("2026-01-15T10:00:00Z"), page: "product" },
  { user_id: "u1", product_id: "p2", ts: new Date("2026-01-15T10:05:00Z"), page: "product" },
  { user_id: "u1", product_id: "p7", ts: new Date("2026-01-15T10:10:00Z"), page: "product" },
  { user_id: "u1", product_id: "p3", ts: new Date("2026-01-16T09:00:00Z"), page: "product" },
  { user_id: "u2", product_id: "p1", ts: new Date("2026-01-16T11:00:00Z"), page: "product" },
  { user_id: "u2", product_id: "p4", ts: new Date("2026-01-17T12:00:00Z"), page: "product" },
  { user_id: "u3", product_id: "p5", ts: new Date("2026-01-17T13:00:00Z"), page: "product" },
  { user_id: "u3", product_id: "p6", ts: new Date("2026-01-18T14:00:00Z"), page: "product" },
  { user_id: "u4", product_id: "p9", ts: new Date("2026-01-18T15:00:00Z"), page: "product" },
  { user_id: "u5", product_id: "p4", ts: new Date("2026-01-19T16:00:00Z"), page: "product" },
  { user_id: "u1", product_id: "p9", ts: new Date("2026-02-01T10:00:00Z"), page: "product" },
  { user_id: "u2", product_id: "p7", ts: new Date("2026-02-03T11:00:00Z"), page: "product" },
]);

// ─── 6. CREATE INDEXES ───────────────────────────────────────────────────────
db.orders.createIndex({ order_date: 1 });
db.orders.createIndex({ user_id: 1, order_date: 1 });
db.clicks.createIndex({ user_id: 1, ts: -1 });

// ─── 7. AGGREGATION 1: Revenue by category ──────────────────────────────────
print("=== Aggregation 1: Revenue by Category ===");
const revenueByCategory = db.orders.aggregate([
  { $unwind: "$items" },
  { $group: {
      _id: { category: "$items.category" },
      total_revenue: { $sum: { $multiply: ["$items.quantity", "$items.price"] } },
      order_count: { $sum: 1 }
  }},
  { $sort: { total_revenue: -1 } }
]).toArray();
printjson(revenueByCategory);

// ─── 8. AGGREGATION 2: Top 5 products per category ──────────────────────────
print("=== Aggregation 2: Top 5 Products per Category ===");
const topProducts = db.orders.aggregate([
  { $unwind: "$items" },
  { $group: {
      _id: { category: "$items.category", product_id: "$items.product_id" },
      total_revenue: { $sum: { $multiply: ["$items.quantity", "$items.price"] } }
  }},
  { $sort: { "_id.category": 1, total_revenue: -1 } },
  { $group: {
      _id: "$_id.category",
      products: { $push: "$$ROOT" }
  }},
  { $project: {
      _id: 0,
      category: "$_id",
      top_products: { $slice: ["$products", 5] }
  }}
]).toArray();
printjson(topProducts);

// ─── 9. QUERY: Last 10 clicks for a user ────────────────────────────────────
print("=== Query: Last 10 Clicks for u1 ===");
const lastClicks = db.clicks.find({ user_id: "u1" }).sort({ ts: -1 }).limit(10).toArray();
printjson(lastClicks);

// ─── 10. EXPLAIN: Index usage on orders ─────────────────────────────────────
print("=== Explain: Index usage on orders ===");
const explainResult = db.orders.find({ order_date: { $gte: new Date("2026-01-01") } })
  .explain("executionStats");
printjson(explainResult);

print("=== Done ===");
