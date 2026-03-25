"""
Shared fixtures for Assignment 3 autograding tests.
Each fixture skips gracefully if the backing service is unavailable,
so students see a clear SKIP reason rather than a hard connection error.
"""

import pytest
from pymongo import MongoClient
from pymongo.errors import ConnectionFailure, ServerSelectionTimeoutError
from cassandra.cluster import Cluster
from cassandra.cluster import NoHostAvailable


@pytest.fixture(scope="session")
def mongo_client():
    try:
        client = MongoClient("localhost", 27017, serverSelectionTimeoutMS=5000)
        client.admin.command("ping")
        yield client
        client.close()
    except (ConnectionFailure, ServerSelectionTimeoutError) as exc:
        pytest.skip(f"MongoDB unavailable: {exc}")


@pytest.fixture(scope="session")
def mongo_db(mongo_client):
    return mongo_client["ecommerce"]


@pytest.fixture(scope="session")
def cassandra_session():
    try:
        cluster = Cluster(["localhost"], connect_timeout=30)
        session = cluster.connect()
        yield session
        cluster.shutdown()
    except NoHostAvailable as exc:
        pytest.skip(f"Cassandra unavailable: {exc}")
