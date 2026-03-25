"""
MongoDB tests — 19 points total.
Tests run after the student's mongo/commands.js has been executed by the workflow.
"""

import json
import os
import pytest


# ── Collection existence ──────────────────────────────────────────────────────

def test_collections_exist(mongo_db):
    """All four required collections exist in the ecommerce database."""
    existing = set(mongo_db.list_collection_names())
    required = {"orders", "products", "users", "clicks"}
    missing = required - existing
    assert not missing, \
        f"Missing collections: {missing}. Check your insertMany() and mongoimport calls."


# ── Schema correctness ────────────────────────────────────────────────────────

def test_orders_embedded_items(mongo_db):
    """Orders have an embedded 'items' array (not a separate collection)."""
    order = mongo_db.orders.find_one({"items": {"$exists": True, "$type": "array"}})
    assert order is not None, \
        "No orders found with an 'items' array — orders must embed line items"
    assert isinstance(order["items"], list) and len(order["items"]) > 0, \
        "'items' must be a non-empty array of line items"
    # Each item must have at minimum product_id and price
    item = order["items"][0]
    for field in ("product_id", "price"):
        assert field in item, \
            f"Line item missing required field '{field}'"


def test_orders_user_id_ref(mongo_db):
    """Orders use a scalar user_id reference, not an embedded user document."""
    order = mongo_db.orders.find_one()
    assert order is not None, "No orders found"
    assert "user_id" in order, \
        "Orders must have a 'user_id' field (reference to the users collection)"
    assert not isinstance(order["user_id"], dict), \
        "'user_id' must be a scalar reference (string), not an embedded document"


# ── Aggregation correctness ───────────────────────────────────────────────────

def test_revenue_category_agg(mongo_db):
    """Revenue-by-category-and-day aggregation returns results with correct fields."""
    pipeline = [
        {"$unwind": "$items"},
        {"$group": {
            "_id": {"category": "$items.category"},
            "total_revenue": {"$sum": {"$multiply": ["$items.quantity", "$items.price"]}},
            "order_count": {"$sum": 1},
        }},
    ]
    results = list(mongo_db.orders.aggregate(pipeline))
    assert len(results) > 0, \
        "Revenue-by-category aggregation returned 0 results — verify orders have items with category/price/quantity"
    first = results[0]
    assert "total_revenue" in first, "Aggregation result missing 'total_revenue'"
    assert first["total_revenue"] > 0, "'total_revenue' must be a positive number"


def test_top_products_agg(mongo_db):
    """Top-5-products-per-category aggregation returns results."""
    pipeline = [
        {"$unwind": "$items"},
        {"$group": {
            "_id": {
                "category": "$items.category",
                "product_id": "$items.product_id",
            },
            "total_revenue": {"$sum": {"$multiply": ["$items.quantity", "$items.price"]}},
        }},
        {"$sort": {"_id.category": 1, "total_revenue": -1}},
        {"$group": {
            "_id": "$_id.category",
            "products": {"$push": "$$ROOT"},
        }},
        {"$project": {
            "_id": 0,
            "category": "$_id",
            "top_products": {"$slice": ["$products", 5]},
        }},
    ]
    results = list(mongo_db.orders.aggregate(pipeline))
    assert len(results) > 0, \
        "Top-products aggregation returned 0 results"
    for cat_doc in results:
        assert len(cat_doc.get("top_products", [])) <= 5, \
            f"Category '{cat_doc.get('category')}' has more than 5 products in top_products"


def test_clicks_query(mongo_db):
    """Last-10-clicks query returns results sorted by ts descending."""
    sample_click = mongo_db.clicks.find_one()
    assert sample_click is not None, \
        "clicks collection is empty — insert click data in commands.js"
    user_id = sample_click["user_id"]
    results = list(
        mongo_db.clicks.find({"user_id": user_id}).sort("ts", -1).limit(10)
    )
    assert len(results) > 0, \
        f"Click query for user_id='{user_id}' returned no results"
    assert len(results) <= 10, "limit(10) not applied — query returned more than 10 results"
    # Verify descending sort (each ts >= next ts)
    if len(results) > 1:
        for i in range(len(results) - 1):
            assert results[i]["ts"] >= results[i + 1]["ts"], \
                "Clicks are not sorted by ts descending"


# ── Indexes ───────────────────────────────────────────────────────────────────

def test_indexes_exist(mongo_db):
    """Custom indexes exist on orders and clicks collections."""
    order_indexes = mongo_db.orders.index_information()
    # _id index is always present; we need at least one custom index
    assert len(order_indexes) > 1, \
        "No custom indexes found on orders — create indexes to support aggregations 1 and 2"

    click_indexes = mongo_db.clicks.index_information()
    assert len(click_indexes) > 1, \
        "No custom indexes found on clicks — create an index to support the last-10-clicks query"


def test_orders_index_covers_order_date(mongo_db):
    """An index on orders supports queries by order_date."""
    indexes = mongo_db.orders.index_information()
    # Look for any index whose key list includes order_date
    has_date_index = any(
        any(k == "order_date" for k, _ in idx["key"])
        for idx in indexes.values()
    )
    assert has_date_index, \
        "No index found on orders.order_date — the revenue-by-category aggregation needs one"


def test_clicks_index_covers_user_ts(mongo_db):
    """An index on clicks supports (user_id, ts) queries."""
    indexes = mongo_db.clicks.index_information()
    has_user_ts = any(
        any(k == "user_id" for k, _ in idx["key"])
        for idx in indexes.values()
    )
    assert has_user_ts, \
        "No index on clicks.user_id found — create a compound (user_id, ts) index"
