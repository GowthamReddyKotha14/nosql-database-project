"""
Structure and documentation checks — 11 points total.
These tests run without any database connection.
"""

import json
import os
import re

REQUIRED_FILES = [
    "mongo/commands.js",
    "mongo/sample_outputs.json",
    "cassandra/schema.cql",
    "cassandra/queries.cql",
    "analysis/tradeoffs.md",
    "README.md",
    "DESIGN_RATIONALE.md",
]

PLACEHOLDER_COMMENT = "Replace this file"


def _read(path):
    with open(path, encoding="utf-8") as f:
        return f.read()


# ── File existence (5 pts) ────────────────────────────────────────────────────

def test_required_files_exist():
    """All required files are present in the repository."""
    missing = [f for f in REQUIRED_FILES if not os.path.exists(f)]
    assert not missing, f"Missing required files: {missing}"


# ── File content — not just placeholders ─────────────────────────────────────

def test_commands_js_not_empty():
    """mongo/commands.js has been filled in (>200 bytes of real content)."""
    assert os.path.exists("mongo/commands.js"), "mongo/commands.js missing"
    assert os.path.getsize("mongo/commands.js") > 200, \
        "mongo/commands.js is too small — complete the TODO blocks"


def test_schema_cql_not_empty():
    """cassandra/schema.cql has been filled in (>200 bytes of real content)."""
    assert os.path.exists("cassandra/schema.cql"), "cassandra/schema.cql missing"
    content = _read("cassandra/schema.cql")
    assert "CREATE TABLE" in content.upper(), \
        "cassandra/schema.cql must contain at least one CREATE TABLE statement"


def test_design_rationale():
    """DESIGN_RATIONALE.md has been filled in (>100 words)."""
    assert os.path.exists("DESIGN_RATIONALE.md"), "DESIGN_RATIONALE.md missing"
    words = _read("DESIGN_RATIONALE.md").split()
    assert len(words) >= 100, \
        f"DESIGN_RATIONALE.md too short ({len(words)} words); add your design decisions"


def test_readme_has_run_instructions():
    """README.md contains MongoDB and Cassandra run commands."""
    assert os.path.exists("README.md"), "README.md missing"
    content = _read("README.md").lower()
    assert "mongosh" in content or "mongoimport" in content, \
        "README.md must include MongoDB run instructions (mongosh or mongoimport)"
    assert "cqlsh" in content, \
        "README.md must include Cassandra run instructions (cqlsh)"


# ── Analysis quality ─────────────────────────────────────────────────────────

def test_tradeoffs_min_length():
    """analysis/tradeoffs.md meets the 2–3 page minimum (~300 words)."""
    assert os.path.exists("analysis/tradeoffs.md"), "analysis/tradeoffs.md missing"
    words = _read("analysis/tradeoffs.md").split()
    assert len(words) >= 300, \
        f"tradeoffs.md too short ({len(words)} words); a 2–3 page analysis requires ≥300 words"


def _has_any(content, *terms):
    """Return True if any of the terms appear as whole words in content."""
    import re
    for term in terms:
        if re.search(r'\b' + re.escape(term) + r'\b', content):
            return True
    return False


def test_tradeoffs_topic_cap():
    """tradeoffs.md discusses CAP theorem and consistency trade-offs."""
    content = _read("analysis/tradeoffs.md").lower()
    assert _has_any(content, "cap theorem", "cap positioning", "consistency, availability",
                    "consistency and availability", "cp database", "ap database",
                    "partition tolerance"), \
        "tradeoffs.md must discuss the CAP theorem (Topic 2). " \
        "Mention 'CAP theorem', CP/AP classification, or partition tolerance."


def test_tradeoffs_topic_schema_design():
    """tradeoffs.md discusses embedding vs. references vs. denormalization."""
    content = _read("analysis/tradeoffs.md").lower()
    assert _has_any(content, "embed", "denormali", "reference", "schema design",
                    "document model", "normali"), \
        "tradeoffs.md must discuss schema design philosophy (Topic 1). " \
        "Address embedding vs. references (MongoDB) and denormalization (Cassandra)."


def test_tradeoffs_topic_query_flexibility():
    """tradeoffs.md compares MQL aggregation pipeline with CQL query constraints."""
    content = _read("analysis/tradeoffs.md").lower()
    assert _has_any(content, "aggregation pipeline", "pipeline", "mql", "cql",
                    "one table per query", "access pattern", "query flexibility"), \
        "tradeoffs.md must compare query flexibility (Topic 3). " \
        "Discuss MQL's aggregation pipeline vs. CQL's one-table-per-query constraint."


def test_tradeoffs_topic_write_performance():
    """tradeoffs.md discusses write/read performance differences."""
    content = _read("analysis/tradeoffs.md").lower()
    assert _has_any(content, "wiredtiger", "memtable", "sstable", "log-structured",
                    "compaction", "write path", "lsm", "b-tree"), \
        "tradeoffs.md must compare write/read performance (Topic 4). " \
        "Reference Cassandra's SSTable/memtable write path and/or MongoDB's WiredTiger."


def test_tradeoffs_topic_when_to_use():
    """tradeoffs.md gives concrete scenarios for choosing each database."""
    content = _read("analysis/tradeoffs.md").lower()
    has_mongo = _has_any(content, "choose mongodb", "use mongodb", "mongodb when",
                         "prefer mongodb", "mongodb is better", "mongodb works well")
    has_cassandra = _has_any(content, "choose cassandra", "use cassandra", "cassandra when",
                             "prefer cassandra", "cassandra is better", "cassandra works well")
    assert has_mongo and has_cassandra, \
        "tradeoffs.md must give concrete scenarios for both databases (Topic 5). " \
        "Include a 'Choose MongoDB when' and a 'Choose Cassandra when' section."


# ── Cassandra consistency requirement ─────────────────────────────────────────

def test_consistency_quorum():
    """cassandra/queries.cql includes a CONSISTENCY QUORUM statement."""
    assert os.path.exists("cassandra/queries.cql"), "cassandra/queries.cql missing"
    content = _read("cassandra/queries.cql").upper()
    assert "CONSISTENCY QUORUM" in content, \
        "cassandra/queries.cql must include 'CONSISTENCY QUORUM' (Part 2, requirement 6)"


# ── sample_outputs.json is real output, not the placeholder ──────────────────

def test_sample_outputs():
    """mongo/sample_outputs.json contains actual query results."""
    assert os.path.exists("mongo/sample_outputs.json"), "mongo/sample_outputs.json missing"
    try:
        data = json.loads(_read("mongo/sample_outputs.json"))
    except json.JSONDecodeError as exc:
        pytest.fail(f"mongo/sample_outputs.json is not valid JSON: {exc}")
    assert PLACEHOLDER_COMMENT not in str(data), \
        "mongo/sample_outputs.json still contains the placeholder — replace with real output"
    # Must have at least one non-empty list
    lists = [v for v in data.values() if isinstance(v, list) and len(v) > 0]
    assert lists, "mongo/sample_outputs.json must contain at least one non-empty result array"
