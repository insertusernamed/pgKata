import os
import json
import sys
import pytest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from verify import (
    find_challenges, verify_query, verify_state,
    load_text, load_json, get_connection,
    CHALLENGES_DIR, execute_sql,
)


def _load_solution(challenge_path):
    sol_path = os.path.join(challenge_path, "solution.sql")
    if os.path.exists(sol_path):
        return load_text(sol_path)
    return None


def _discover_challenge_ids():
    ids = []
    for c in find_challenges():
        ids.append(c["id"])
    return ids


CHALLENGE_IDS = _discover_challenge_ids()


@pytest.mark.parametrize("challenge_id", CHALLENGE_IDS)
def test_challenge(db_conn, challenge_id):
    expected, setup_sql, user_sql = None, "", None
    challenge_path = None

    p = os.path.join(CHALLENGES_DIR, challenge_id)
    ep = os.path.join(p, "expected.json")
    assert os.path.exists(ep), f"Challenge {challenge_id} not found"
    challenge_path = p
    expected = load_json(ep)

    setup_path = os.path.join(challenge_path, "setup.sql")
    if os.path.exists(setup_path):
        setup_sql = load_text(setup_path)

    mode = expected.get("mode", "query")

    if mode == "query":
        user_sql = _load_solution(challenge_path)
        assert user_sql is not None, (
            f"No solution.sql found for {challenge_id}. "
            f"Create solution.sql with the correct query."
        )
        result = verify_query(db_conn, setup_sql, user_sql, expected)

    elif mode == "state":
        user_sql = _load_solution(challenge_path)
        assert user_sql is not None, (
            f"No solution.sql found for {challenge_id}."
        )
        if setup_sql:
            r = execute_sql(db_conn, setup_sql)
            errors = [x for x in r if x.get("type") == "error"]
            assert not errors, f"Setup error: {errors[0]['error']}"
        r = execute_sql(db_conn, user_sql)
        errors = [x for x in r if x.get("type") == "error"]
        assert not errors, f"SQL execution error: {errors[0]['error']}"
        result = verify_state(db_conn, "", expected)

    else:
        pytest.fail(f"Unknown mode: {mode}")

    assert result.passed, result.message
