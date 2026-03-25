"""
Cassandra tests — 20 points total.
Tests run after the student's schema.cql and queries.cql have been loaded by the workflow.
"""

import pytest


# ── Keyspace ──────────────────────────────────────────────────────────────────

def test_keyspace_exists(cassandra_session):
    """Keyspace 'ecommerce' exists."""
    rows = cassandra_session.execute(
        "SELECT keyspace_name FROM system_schema.keyspaces "
        "WHERE keyspace_name = 'ecommerce'"
    )
    assert rows.one() is not None, \
        "Keyspace 'ecommerce' not found — check your CREATE KEYSPACE statement in schema.cql"


def test_keyspace_replication(cassandra_session):
    """Keyspace 'ecommerce' uses replication_factor = 3."""
    rows = cassandra_session.execute(
        "SELECT replication FROM system_schema.keyspaces "
        "WHERE keyspace_name = 'ecommerce'"
    )
    row = rows.one()
    assert row is not None, "Keyspace 'ecommerce' not found"
    rf = row.replication.get("replication_factor", "0")
    assert str(rf) == "3", \
        f"Expected replication_factor = 3, got {rf!r}. Update your CREATE KEYSPACE statement."


# ── Table existence ───────────────────────────────────────────────────────────

def test_orders_table_exists(cassandra_session):
    """Table 'orders_by_user_date' exists in the ecommerce keyspace."""
    rows = cassandra_session.execute(
        "SELECT table_name FROM system_schema.tables "
        "WHERE keyspace_name = 'ecommerce' AND table_name = 'orders_by_user_date'"
    )
    assert rows.one() is not None, \
        "Table 'orders_by_user_date' not found — create it in cassandra/schema.cql"


def test_revenue_table_exists(cassandra_session):
    """Table 'revenue_by_category_date' exists in the ecommerce keyspace."""
    rows = cassandra_session.execute(
        "SELECT table_name FROM system_schema.tables "
        "WHERE keyspace_name = 'ecommerce' AND table_name = 'revenue_by_category_date'"
    )
    assert rows.one() is not None, \
        "Table 'revenue_by_category_date' not found — create it in cassandra/schema.cql"


def test_clicks_table_exists(cassandra_session):
    """Table 'clicks_by_user' exists in the ecommerce keyspace."""
    rows = cassandra_session.execute(
        "SELECT table_name FROM system_schema.tables "
        "WHERE keyspace_name = 'ecommerce' AND table_name = 'clicks_by_user'"
    )
    assert rows.one() is not None, \
        "Table 'clicks_by_user' not found — create it in cassandra/schema.cql"


# ── Partition and clustering key correctness ──────────────────────────────────

def _column_kinds(session, table_name):
    """Return {column_name: kind} dict for a table in the ecommerce keyspace."""
    rows = session.execute(
        "SELECT column_name, kind FROM system_schema.columns "
        "WHERE keyspace_name = 'ecommerce' AND table_name = %s",
        (table_name,),
    )
    return {row.column_name: row.kind for row in rows}


def test_orders_partition_key(cassandra_session):
    """orders_by_user_date uses (user_id, order_date) as a composite partition key."""
    cols = _column_kinds(cassandra_session, "orders_by_user_date")
    assert cols, "orders_by_user_date has no columns — check your CREATE TABLE statement"
    assert cols.get("user_id") == "partition_key", \
        "user_id must be a partition_key in orders_by_user_date"
    assert cols.get("order_date") == "partition_key", \
        "order_date must be a partition_key in orders_by_user_date (composite partition key)"
    assert cols.get("order_ts") == "clustering", \
        "order_ts must be a clustering column in orders_by_user_date"


def test_revenue_partition_key(cassandra_session):
    """revenue_by_category_date uses (category, order_date) as a composite partition key."""
    cols = _column_kinds(cassandra_session, "revenue_by_category_date")
    assert cols, "revenue_by_category_date has no columns — check your CREATE TABLE statement"
    assert cols.get("category") == "partition_key", \
        "category must be a partition_key in revenue_by_category_date"
    assert cols.get("order_date") == "partition_key", \
        "order_date must be a partition_key in revenue_by_category_date"


def test_clicks_partition_key(cassandra_session):
    """clicks_by_user uses user_id as partition key and click_ts as clustering column."""
    cols = _column_kinds(cassandra_session, "clicks_by_user")
    assert cols, "clicks_by_user has no columns — check your CREATE TABLE statement"
    assert cols.get("user_id") == "partition_key", \
        "user_id must be the partition_key in clicks_by_user"
    assert cols.get("click_ts") == "clustering", \
        "click_ts must be a clustering column in clicks_by_user"


# ── Row counts (≥ 10 per table) ───────────────────────────────────────────────

def test_orders_has_data(cassandra_session):
    """orders_by_user_date has at least 10 rows."""
    row = cassandra_session.execute(
        "SELECT COUNT(*) FROM ecommerce.orders_by_user_date"
    ).one()
    assert row.count >= 10, \
        f"orders_by_user_date has {row.count} rows; insert at least 10"


def test_revenue_has_data(cassandra_session):
    """revenue_by_category_date has at least 10 rows."""
    row = cassandra_session.execute(
        "SELECT COUNT(*) FROM ecommerce.revenue_by_category_date"
    ).one()
    assert row.count >= 10, \
        f"revenue_by_category_date has {row.count} rows; insert at least 10"


def test_clicks_has_data(cassandra_session):
    """clicks_by_user has at least 10 rows."""
    row = cassandra_session.execute(
        "SELECT COUNT(*) FROM ecommerce.clicks_by_user"
    ).one()
    assert row.count >= 10, \
        f"clicks_by_user has {row.count} rows; insert at least 10"


# ── Query correctness ─────────────────────────────────────────────────────────

def test_query_orders_partition(cassandra_session):
    """Query on orders_by_user_date using full partition key returns results."""
    sample = cassandra_session.execute(
        "SELECT user_id, order_date FROM ecommerce.orders_by_user_date LIMIT 1"
    ).one()
    assert sample is not None, "No data in orders_by_user_date"
    results = list(cassandra_session.execute(
        "SELECT * FROM ecommerce.orders_by_user_date "
        "WHERE user_id = %s AND order_date = %s",
        (sample.user_id, sample.order_date),
    ))
    assert len(results) > 0, \
        "Partition key query on orders_by_user_date returned no results"


def test_query_clicks_limit(cassandra_session):
    """Last-10-clicks query on clicks_by_user returns ≤ 10 rows."""
    sample = cassandra_session.execute(
        "SELECT user_id FROM ecommerce.clicks_by_user LIMIT 1"
    ).one()
    assert sample is not None, "No data in clicks_by_user"
    results = list(cassandra_session.execute(
        "SELECT * FROM ecommerce.clicks_by_user WHERE user_id = %s LIMIT 10",
        (sample.user_id,),
    ))
    assert len(results) > 0, \
        "Last-10-clicks query on clicks_by_user returned no results"
    assert len(results) <= 10, \
        f"LIMIT 10 not applied — query returned {len(results)} rows"
