import pytest
import os
import sys
import psycopg2

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from verify import DB_CONFIG, reset_database, get_connection


@pytest.fixture(scope="session")
def db_setup():
    """Create and reset the test database once per session."""
    try:
        conn = psycopg2.connect(
            dbname="postgres",
            user=DB_CONFIG["user"],
            host=DB_CONFIG["host"],
            port=DB_CONFIG["port"],
        )
        conn.autocommit = True
        cur = conn.cursor()
        dbname = DB_CONFIG["dbname"]
        cur.execute(f"""
            SELECT pg_terminate_backend(pg_stat_activity.pid)
            FROM pg_stat_activity
            WHERE pg_stat_activity.datname = '{dbname}'
              AND pid <> pg_backend_pid()
        """)
        cur.execute(f"DROP DATABASE IF EXISTS {dbname}")
        cur.execute(f"CREATE DATABASE {dbname}")
        cur.close()
        conn.close()
    except Exception as e:
        pytest.skip(f"Cannot create test database: {e}")

    yield

    conn = psycopg2.connect(
        dbname="postgres",
        user=DB_CONFIG["user"],
        host=DB_CONFIG["host"],
        port=DB_CONFIG["port"],
    )
    conn.autocommit = True
    cur = conn.cursor()
    cur.execute(f"DROP DATABASE IF EXISTS {DB_CONFIG['dbname']}")
    cur.close()
    conn.close()


@pytest.fixture
def db_conn(db_setup):
    """Provide a fresh database connection per test."""
    conn = get_connection()
    conn.autocommit = True
    yield conn
    conn.close()
