import json
import os
import psycopg2

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CHALLENGES_DIR = os.path.join(BASE_DIR, "challenges")

DB_CONFIG = {
    "dbname": os.environ.get("PGTESTDB", "levelup_test"),
    "user": os.environ.get("PGUSER", "admin"),
    "host": os.environ.get("PGHOST", "localhost"),
    "port": os.environ.get("PGPORT", "5432"),
}


class VerifyResult:
    def __init__(self, passed, message, expected=None, actual=None):
        self.passed = passed
        self.message = message
        self.expected = expected
        self.actual = actual

    def to_dict(self):
        return {
            "passed": self.passed,
            "message": self.message,
            "expected": self.expected,
            "actual": self.actual,
        }


def get_connection():
    return psycopg2.connect(**DB_CONFIG)


def reset_database():
    conn = get_connection()
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


def split_sql_statements(sql):
    """Split SQL on semicolons, respecting dollar-quoted strings ($...$)."""
    statements = []
    current = []
    i = 0
    in_dollar = False
    dollar_tag = ""
    while i < len(sql):
        c = sql[i]
        if not in_dollar and c == '$':
            j = i + 1
            tag = ""
            while j < len(sql) and sql[j] != '$':
                tag += sql[j]
                j += 1
            if j < len(sql) and sql[j] == '$':
                in_dollar = True
                dollar_tag = tag
                current.append(sql[i:j+1])
                i = j + 1
                continue
        if in_dollar:
            current.append(c)
            if c == '$':
                k = i + 1
                end_tag = ""
                while k < len(sql) and sql[k] != '$':
                    end_tag += sql[k]
                    k += 1
                if k < len(sql) and sql[k] == '$' and end_tag == dollar_tag:
                    current.append('$')
                    in_dollar = False
                    dollar_tag = ""
                    i = k
        elif c == ';':
            stmt = ''.join(current).strip()
            if stmt:
                statements.append(stmt)
            current = []
        else:
            current.append(c)
        i += 1
    stmt = ''.join(current).strip()
    if stmt:
        statements.append(stmt)
    return statements


def execute_sql(conn, sql, fetch=False):
    results = []
    cur = conn.cursor()
    statements = split_sql_statements(sql)
    for stmt in statements:
        try:
            cur.execute(stmt)
            if fetch and cur.description:
                cols = [desc[0] for desc in cur.description]
                rows = cur.fetchall()
                results.append({
                    "type": "select",
                    "columns": cols,
                    "rows": [[str(c) for c in r] for r in rows],
                })
            elif cur.description:
                cur.fetchall()
        except Exception as e:
            results.append({"type": "error", "error": str(e)})
            break
    cur.close()
    return results


def find_challenges(base_dir=None):
    if base_dir is None:
        return sorted(_find_in_dir(CHALLENGES_DIR), key=lambda c: c["id"])
    return _find_in_dir(base_dir)


def _find_in_dir(base_dir):
    challenges = []
    for root, dirs, files in os.walk(base_dir):
        if "expected.json" in files:
            rel = os.path.relpath(root, base_dir)
            info_path = os.path.join(root, "info.json")
            info = {}
            if os.path.exists(info_path):
                with open(info_path) as f:
                    info = json.load(f)
            challenges.append({
                "id": rel,
                "path": root,
                "title": info.get("title", rel),
                "difficulty": info.get("difficulty", "medium"),
                "description": info.get("description", ""),
                "hints": info.get("hints", []),
            })
    return challenges


def load_json(path):
    with open(path) as f:
        return json.load(f)


def load_text(path):
    with open(path) as f:
        return f.read()


def compare_result_sets(actual_rows, actual_cols, expected):
    exp_cols = expected["columns"]
    exp_rows = expected["rows"]

    actual_cols_lower = [c.lower() for c in actual_cols]
    exp_cols_lower = [c.lower() for c in exp_cols]

    if actual_cols_lower != exp_cols_lower:
        return VerifyResult(
            False,
            f"Column mismatch.\nExpected: {exp_cols}\nActual:   {actual_cols}",
            {"columns": exp_cols, "rows": list(exp_rows)},
            {"columns": actual_cols, "rows": actual_rows},
        )

    actual_set = set(
        tuple(str(c) for c in row) for row in actual_rows
    )
    expected_set = set(
        tuple(str(c) for c in row) for row in exp_rows
    )

    if actual_set == expected_set:
        return VerifyResult(True, f"Passed ({len(actual_rows)} rows)")
    else:
        missing = expected_set - actual_set
        extra = actual_set - expected_set
        parts = []
        if missing:
            shown = list(missing)[:5]
            parts.append(f"Missing {len(missing)} row(s): {shown}")
        if extra:
            shown = list(extra)[:5]
            parts.append(f"Extra {len(extra)} row(s): {shown}")
        return VerifyResult(
            False,
            "; ".join(parts),
            {"columns": exp_cols, "rows": sorted(list(expected_set))},
            {"columns": actual_cols, "rows": sorted(list(actual_set))},
        )


def verify_query(conn, setup_sql, user_sql, expected):
    if setup_sql:
        setup_result = execute_sql(conn, setup_sql)
        for r in setup_result:
            if r.get("type") == "error":
                return VerifyResult(False, f"Setup error: {r['error']}")

    results = execute_sql(conn, user_sql, fetch=True)

    select_results = [r for r in results if r.get("type") == "select"]
    errors = [r for r in results if r.get("type") == "error"]

    if errors:
        return VerifyResult(False, f"Query error: {errors[0]['error']}")

    if not select_results:
        return VerifyResult(False, "Query did not return any columns (expected SELECT)")

    last_select = select_results[-1]
    actual_cols = last_select["columns"]
    actual_rows = last_select["rows"]

    return compare_result_sets(actual_rows, actual_cols, expected)


def verify_state(conn, setup_sql, expected):
    if setup_sql:
        setup_result = execute_sql(conn, setup_sql)
        for r in setup_result:
            if r.get("type") == "error":
                return VerifyResult(False, f"Setup error: {r['error']}")

    checks = expected.get("checks", [])
    for i, check in enumerate(checks):
        q = check["query"]
        exp = check["expected"]
        cur = conn.cursor()
        try:
            cur.execute(q)
        except Exception as e:
            cur.close()
            return VerifyResult(False, f"Check {i} error: {str(e)}")
        actual = cur.fetchall()
        cur.close()

        actual_str = [[str(c) for c in row] for row in actual]
        exp_str = [[str(c) for c in row] for row in exp]

        if actual_str != exp_str:
            return VerifyResult(
                False,
                f"Check {i} failed.\nQuery: {q}\nExpected: {exp_str}\nActual:   {actual_str}",
                exp_str,
                actual_str,
            )

    return VerifyResult(True, "All state checks passed")


def verify_challenge(challenge_id, user_sql=None):
    p = os.path.join(CHALLENGES_DIR, challenge_id)
    ep = os.path.join(p, "expected.json")
    if not os.path.exists(ep):
        return VerifyResult(False, f"Challenge '{challenge_id}' not found")
    challenge_path = p

    expected = load_json(ep)
    mode = expected.get("mode", "query")

    setup_sql = ""
    setup_path = os.path.join(challenge_path, "setup.sql")
    if os.path.exists(setup_path):
        setup_sql = load_text(setup_path)

    conn = get_connection()
    conn.autocommit = True
    try:
        if mode == "query":
            if user_sql is None:
                return VerifyResult(False, "user_sql is required for query mode")
            return verify_query(conn, setup_sql, user_sql, expected)
        elif mode == "state":
            if user_sql is None:
                return VerifyResult(False, "user_sql is required for state mode")
            if setup_sql:
                setup_result = execute_sql(conn, setup_sql)
                for r in setup_result:
                    if r.get("type") == "error":
                        return VerifyResult(False, f"Setup error: {r['error']}")
            user_result = execute_sql(conn, user_sql)
            for r in user_result:
                if r.get("type") == "error":
                    return VerifyResult(False, f"SQL error: {r['error']}")
            return verify_state(conn, "", expected)
        else:
            return VerifyResult(False, f"Unknown mode: {mode}")
    finally:
        conn.close()
