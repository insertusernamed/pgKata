import os
import sys
import json
import subprocess

from flask import Flask, jsonify, request, render_template, session
import psycopg2

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
os.environ["PGTESTDB"] = "levelup"

sys.path.insert(0, os.path.join(BASE_DIR, "tests"))
from verify import (
    find_challenges, verify_challenge, load_json, load_text,
    split_sql_statements,
    CHALLENGES_DIR as CHALLENGES_DIR,
)

app = Flask(__name__)
app.secret_key = "psql-mastery-secret-key"
PROGRESS_FILE = os.path.join(BASE_DIR, "progress.json")
DB_NAME = "levelup"

DB_CONFIG = {
    "dbname": DB_NAME,
    "user": os.environ.get("PGUSER", os.environ.get("USER", "admin")),
    "host": os.environ.get("PGHOST", "localhost"),
    "port": os.environ.get("PGPORT", "5432"),
}

os.environ.setdefault("PGTESTDB", DB_NAME)

TIERS = [
    {"id": "01_foundations", "label": "01: SQL Foundations", "dirs": ["00_create_table", "01_select_where", "02_order_limit", "03_string_functions", "04_date_functions", "05_aggregate_basics", "06_group_by_having", "07_union_set", "08_insert_records", "09_alter_table", "10_delete_records", "11_phone_formatting"]},
    {"id": "02_joins", "label": "02: Joins & Relationships", "dirs": ["01_inner_join", "02_left_right_join", "03_self_join", "04_multi_join", "05_anti_join"]},
    {"id": "03_aggregation", "label": "03: Aggregation", "dirs": ["00_duplicates", "01_group_basics", "02_having", "03_rollup_cube", "04_filtered_agg", "05_case_aggregation"]},
    {"id": "04_subqueries", "label": "04: Subqueries & CTEs", "dirs": ["00_address_cte", "01_scalar_subquery", "02_derived_table", "03_exists_in", "04_cte", "05_correlated"]},
    {"id": "05_window", "label": "05: Window Functions", "dirs": ["01_row_number", "02_rank_dense", "03_ntile", "04_lag_lead", "05_first_last_value", "06_frames"]},
    {"id": "06_specialties", "label": "06: PostgreSQL Specialties", "dirs": ["00_create_user", "01_jsonb", "02_arrays", "03_fulltext", "04_enums", "05_type_casting", "06_password_encryption"]},
    {"id": "07_plpgsql", "label": "07: PL/pgSQL", "dirs": ["01_basic_function", "02_param_function", "03_set_returning", "04_stored_procedure", "05_trigger"]},
    {"id": "08_expert", "label": "08: Expert PostgreSQL", "dirs": ["01_recursive_cte", "02_isolation_levels", "03_for_update", "04_explain_analyze", "05_partial_index", "06_row_level_security"]},
    {"id": "09_leetcode", "label": "09: LeetCode Practice", "dirs": ["01_department_top3", "02_consecutive", "03_stadium", "04_median", "05_tree_traversal"]},
]

CHALLENGE_TITLES = {
    "02_01": "INSERT customer & order records",
    "02_04": "CREATE bookmarks table & find duplicates",
    "02_06": "Query programs data",
    "03_01": "Format phone numbers",
    "03_03": "ALTER orders with status column",
    "03_04": "Query addresses",
    "03_06": "Encrypt passwords in users table",
    "03_07": "Simulate locked transactions",
}


def get_db_connection(timeout=None):
    conn = psycopg2.connect(**DB_CONFIG)
    if timeout is not None:
        cur = conn.cursor()
        cur.execute(f"SET statement_timeout = '{timeout}ms'")
        cur.close()
        conn.commit()
    return conn


def load_progress():
    if os.path.exists(PROGRESS_FILE):
        with open(PROGRESS_FILE) as f:
            return json.load(f)
    return {}


def save_progress(data):
    with open(PROGRESS_FILE, "w") as f:
        json.dump(data, f, indent=2)


def get_challenges():
    new_chals = find_challenges()
    return new_chals


def execute_sql(sql, conn=None):
    close = False
    if conn is None:
        conn = get_db_connection()
        conn.autocommit = True
        close = True
    cur = conn.cursor()
    results = []
    statements = split_sql_statements(sql)
    for stmt in statements:
        try:
            cur.execute(stmt)
            if cur.description:
                cols = [desc[0] for desc in cur.description]
                rows = cur.fetchall()
                results.append({
                    "type": "select",
                    "columns": cols,
                    "rows": [[str(c) for c in r] for r in rows],
                    "row_count": len(rows),
                })
            else:
                results.append({
                    "type": "execute",
                    "rows_affected": cur.rowcount if cur.rowcount != -1 else None,
                })
        except Exception as e:
            results.append({
                "type": "error",
                "error": str(e),
            })
    cur.close()
    if close:
        conn.close()
    return results


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/api/challenges")
def api_challenges():
    challenges = get_challenges()
    progress = load_progress()
    completed = sum(1 for c in challenges if progress.get(c["id"]))

    tier_progress = {}
    for tier in TIERS:
        ids = [os.path.join(tier["id"], d) for d in tier["dirs"]]
        done = sum(1 for cid in ids if progress.get(cid))
        tier_progress[tier["label"]] = {"completed": done, "total": len(ids)}

    return jsonify({
        "challenges": challenges,
        "progress": progress,
        "completed": completed,
        "total": len(challenges),
        "tiers": TIERS,
        "tier_progress": tier_progress,
    })


@app.route("/api/challenges/<path:folder>")
def api_challenge_folder(folder):
    for base_dir in [CHALLENGES_DIR]:
        folder_path = os.path.join(base_dir, folder)
        if os.path.isdir(folder_path):
            info = {}
            info_path = os.path.join(folder_path, "info.json")
            if os.path.exists(info_path):
                with open(info_path) as f:
                    info = json.load(f)
            files_content = {}
            for fname in sorted(os.listdir(folder_path)):
                if fname.endswith(".sql") and fname not in ("setup.sql", "solution.sql"):
                    with open(os.path.join(folder_path, fname)) as f:
                        files_content[fname] = f.read()
            return jsonify({"folder": folder, "files": files_content, "info": info})
    return jsonify({"error": "Folder not found"}), 404


@app.route("/api/run", methods=["POST"])
def api_run():
    data = request.get_json()
    sql = data.get("sql", "").strip()
    if not sql:
        return jsonify({"error": "No SQL provided"}), 400
    try:
        results = execute_sql(sql)
        return jsonify({"results": results})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/api/verify", methods=["POST"])
def api_verify():
    data = request.get_json()
    challenge_id = data.get("challenge_id", "")
    user_sql = data.get("user_sql", "").strip()

    if not challenge_id or not user_sql:
        return jsonify({"error": "challenge_id and user_sql required"}), 400

    try:
        result = verify_challenge(challenge_id, user_sql)
        return jsonify(result.to_dict())
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/api/hint", methods=["POST"])
def api_hint():
    data = request.get_json()
    challenge_id = data.get("challenge_id", "")
    level = data.get("level", 0)

    for base_dir in [CHALLENGES_DIR]:
        info_path = os.path.join(base_dir, challenge_id, "info.json")
        if os.path.exists(info_path):
            info = load_json(info_path)
            hints = info.get("hints", [])
            if level < len(hints):
                return jsonify({"hint": hints[level], "level": level, "total": len(hints)})
            else:
                return jsonify({"hint": None, "level": level, "total": len(hints)})

    return jsonify({"error": "Challenge not found"}), 404


@app.route("/api/schema")
def api_schema():
    conn = get_db_connection()
    conn.autocommit = True
    cur = conn.cursor()
    try:
        cur.execute("""
            SELECT table_name, column_name, data_type
            FROM information_schema.columns
            WHERE table_schema = 'public'
            ORDER BY table_name, ordinal_position
        """)
        schema = {}
        for table, col, dtype in cur.fetchall():
            if table not in schema:
                schema[table] = []
            schema[table].append({"column": col, "type": dtype})
        return jsonify({"schema": schema})
    except Exception as e:
        return jsonify({"schema": {}, "error": str(e)})
    finally:
        cur.close()
        conn.close()


PSQL_HELP = """Available psql meta-commands:
  \\l           List databases
  \\dn          List schemas
  \\dt          List tables
  \\d  [name]   Describe table (columns + constraints)
  \\d+ [name]   Same as \\d (extended detail)
  \\di          List indexes
  \\dv          List views
  \\df          List functions
  \\du          List roles
  \\x           Toggle expanded display (vertical output)
  \\conninfo    Show connection info
  \\?           Show this help
  SQL          Any SQL statement is executed directly"""


def exec_psql_query(sql):
    conn = get_db_connection(timeout=10000)
    conn.autocommit = True
    cur = conn.cursor()
    try:
        cur.execute(sql)
        if cur.description:
            cols = [desc[0] for desc in cur.description]
            rows = cur.fetchall()
            return {"columns": cols, "rows": [[str(c) for c in r] for r in rows]}
        return {"columns": [], "rows": [], "message": "Command executed"}
    except Exception as e:
        return {"error": str(e)}
    finally:
        cur.close()
        conn.close()


def format_rel_desc(rows):
    lines = [["Column", "Type", "Nullable", "Default"]]
    lines.append(["-" * 10, "-" * 20, "-" * 10, "-" * 20])
    for col, dtype, nullable, default in rows:
        lines.append([col, dtype, "YES" if nullable else "NO", default or "null"])
    return lines


@app.route("/api/psql", methods=["POST"])
def api_psql():
    data = request.get_json()
    cmd = data.get("command", "").strip()
    if not cmd:
        return jsonify({"error": "No command"})

    expanded = session.get("psql_expanded", False)

    def respond(r):
        if isinstance(r, dict) and "columns" in r and expanded:
            r["expanded"] = True
        return jsonify(r)

    if cmd.startswith("\\"):
        parts = cmd.split()
        main = parts[0].lower()

        if main == "\\?":
            return jsonify({"text": PSQL_HELP})

        elif main == "\\x":
            session["psql_expanded"] = not expanded
            return jsonify({"text": f"Expanded display is {'on' if not expanded else 'off'}."})

        elif main == "\\l":
            return respond(exec_psql_query(
                "SELECT datname AS name, pg_get_userbyid(datdba) AS owner, "
                "encoding, datcollate AS collate, datctype AS ctype "
                "FROM pg_database ORDER BY datname"
            ))

        elif main == "\\dn":
            return respond(exec_psql_query(
                "SELECT nspname AS schema_name, "
                "pg_get_userbyid(nspowner) AS owner "
                "FROM pg_catalog.pg_namespace ORDER BY nspname"
            ))

        elif main == "\\dt":
            return respond(exec_psql_query(
                "SELECT schemaname AS schema, tablename AS table_name, "
                "tableowner AS owner "
                "FROM pg_catalog.pg_tables "
                "WHERE schemaname NOT IN ('pg_catalog', 'information_schema') "
                "ORDER BY schemaname, tablename"
            ))

        elif main == "\\di":
            return respond(exec_psql_query(
                "SELECT schemaname AS schema, indexname AS index_name, "
                "tablename AS table_name, indexdef AS definition "
                "FROM pg_catalog.pg_indexes "
                "WHERE schemaname NOT IN ('pg_catalog', 'information_schema') "
                "ORDER BY schemaname, tablename, indexname"
            ))

        elif main == "\\dv":
            return respond(exec_psql_query(
                "SELECT schemaname AS schema, viewname AS view_name, "
                "viewowner AS owner "
                "FROM pg_catalog.pg_views "
                "WHERE schemaname NOT IN ('pg_catalog', 'information_schema') "
                "ORDER BY schemaname, viewname"
            ))

        elif main == "\\df":
            return respond(exec_psql_query(
                "SELECT n.nspname AS schema, p.proname AS name, "
                "pg_get_function_result(p.oid) AS result_type, "
                "pg_get_function_arguments(p.oid) AS arguments "
                "FROM pg_proc p "
                "JOIN pg_namespace n ON p.pronamespace = n.oid "
                "WHERE n.nspname NOT IN ('pg_catalog', 'information_schema') "
                "AND p.prokind = 'f' "
                "ORDER BY n.nspname, p.proname"
            ))

        elif main == "\\du":
            return respond(exec_psql_query(
                "SELECT rolname AS role_name, "
                "array_agg(DISTINCT privilege_type) FILTER (WHERE privilege_type IS NOT NULL) AS privileges, "
                "rolsuper AS superuser, rolcreatedb AS create_db "
                "FROM pg_roles "
                "LEFT JOIN information_schema.role_table_grants ON grantee = rolname "
                "GROUP BY rolname, rolsuper, rolcreatedb "
                "ORDER BY rolname"
            ))

        elif main.startswith("\\d") and len(parts) > 1:
            name = parts[1]
            if name == '+':
                name = parts[2] if len(parts) > 2 else ''
            r = exec_psql_query(f"""
                SELECT column_name AS "Column",
                       data_type AS "Type",
                       CASE WHEN is_nullable = 'YES' THEN 'YES' ELSE 'NO' END AS "Nullable",
                       COALESCE(column_default, '') AS "Default"
                FROM information_schema.columns
                WHERE table_schema = 'public'
                  AND table_name = '{name.replace("'", "''")}'
                ORDER BY ordinal_position
            """)
            if r.get("columns"):
                r["label"] = f"Table \"public.{name}\""
                constraints = exec_psql_query(f"""
                    SELECT con.conname AS "Constraint",
                           CASE con.contype
                               WHEN 'p' THEN 'PRIMARY KEY'
                               WHEN 'u' THEN 'UNIQUE'
                               WHEN 'f' THEN 'FOREIGN KEY'
                               WHEN 'c' THEN 'CHECK'
                               WHEN 'n' THEN 'NOT NULL'
                               ELSE contype::text
                           END AS "Type",
                           col.column_name AS "Column(s)"
                    FROM pg_constraint con
                    JOIN pg_class cls ON con.conrelid = cls.oid
                    JOIN pg_namespace n ON cls.relnamespace = n.oid
                    LEFT JOIN information_schema.columns col
                           ON col.table_name = cls.relname
                          AND col.ordinal_position = ANY(con.conkey)
                    WHERE cls.relname = '{name.replace("'", "''")}'
                      AND n.nspname = 'public'
                    ORDER BY con.conname, col.ordinal_position
                """)
                return respond({"label": r["label"], "columns": r["columns"], "rows": r["rows"],
                                "constraints": constraints.get("rows", [])})
            r = exec_psql_query(f"""
                SELECT indexname AS "Index Name",
                       indexdef AS "Definition"
                FROM pg_indexes
                WHERE tablename = '{name.replace("'", "''")}'
                  AND schemaname = 'public'
            """)
            if r.get("rows"):
                r["label"] = f"Indexes on \"public.{name}\""
                return respond(r)
            return respond({"error": f"Did not find any relation named \"{name}\"."})

        elif main in ("\\d", "\\d+"):
            if main == "\\d+" and len(parts) > 1:
                name = parts[1]
                r = exec_psql_query(f"""
                    SELECT column_name AS "Column",
                           data_type AS "Type",
                           CASE WHEN is_nullable = 'YES' THEN 'YES' ELSE 'NO' END AS "Nullable",
                           COALESCE(column_default, '') AS "Default"
                    FROM information_schema.columns
                    WHERE table_schema = 'public'
                      AND table_name = '{name.replace("'", "''")}'
                    ORDER BY ordinal_position
                """)
                if r.get("columns"):
                    r["label"] = f"Table \"public.{name}\""
                    constraints = exec_psql_query(f"""
                        SELECT con.conname AS "Constraint",
                               CASE con.contype
                                   WHEN 'p' THEN 'PRIMARY KEY'
                                   WHEN 'u' THEN 'UNIQUE'
                                   WHEN 'f' THEN 'FOREIGN KEY'
                                   WHEN 'c' THEN 'CHECK'
                                   WHEN 'n' THEN 'NOT NULL'
                                   ELSE contype::text
                               END AS "Type",
                               col.column_name AS "Column(s)"
                        FROM pg_constraint con
                        JOIN pg_class cls ON con.conrelid = cls.oid
                        JOIN pg_namespace n ON cls.relnamespace = n.oid
                        LEFT JOIN information_schema.columns col
                               ON col.table_name = cls.relname
                              AND col.ordinal_position = ANY(con.conkey)
                        WHERE cls.relname = '{name.replace("'", "''")}'
                          AND n.nspname = 'public'
                        ORDER BY con.conname, col.ordinal_position
                    """)
                    return respond({"label": r["label"], "columns": r["columns"], "rows": r["rows"],
                                    "constraints": constraints.get("rows", [])})
                return respond({"error": f"Did not find any relation named \"{name}\"."})
            elif main == "\\d+" and len(parts) == 1:
                return respond(exec_psql_query(
                    "SELECT tablename AS table_name, "
                    "tableowner AS owner, "
                    "(SELECT COUNT(*) FROM information_schema.columns "
                    "WHERE table_schema = 'public' AND table_name = t.tablename) AS columns, "
                    "(SELECT COUNT(*) FROM pg_constraint con "
                    "JOIN pg_class cls ON con.conrelid = cls.oid "
                    "WHERE cls.relname = t.tablename) AS constraints "
                    "FROM pg_catalog.pg_tables t "
                    "WHERE schemaname = 'public' "
                    "ORDER BY tablename"
                ))
            return respond(exec_psql_query(
                "SELECT tablename AS table_name, "
                "tableowner AS owner, "
                "(SELECT COUNT(*) FROM information_schema.columns "
                "WHERE table_schema = 'public' AND table_name = t.tablename) AS columns "
                "FROM pg_catalog.pg_tables t "
                "WHERE schemaname = 'public' "
                "ORDER BY tablename"
            ))

        elif main == "\\conninfo":
            conn = get_db_connection()
            info = {
                "dbname": conn.info.dbname,
                "user": conn.info.user,
                "host": conn.info.host,
                "port": conn.info.port,
            }
            conn.close()
            text = (
                f"You are connected to database \"{info['dbname']}\" "
                f"as user \"{info['user']}\" "
                f"on host \"{info['host']}\" "
                f"at port \"{info['port']}\"."
            )
            return jsonify({"text": text})

        else:
            return jsonify({"error": f"Unknown command: {main}. Type \\? for help."})

    else:
        return respond(exec_psql_query(cmd))


@app.route("/api/progress", methods=["GET", "POST"])
def api_progress():
    if request.method == "POST":
        data = request.get_json()
        save_progress(data)
        return jsonify({"status": "ok"})
    return jsonify(load_progress())


@app.route("/api/reset", methods=["POST"])
def api_reset():
    try:
        subprocess.run(["dropdb", DB_NAME], capture_output=True)
        subprocess.run(["createdb", DB_NAME], capture_output=True)
        return jsonify({"status": "ok", "message": f"Database '{DB_NAME}' recreated"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/api/checkpoint", methods=["POST"])
def api_checkpoint():
    data = request.get_json()
    checkpoint = data.get("checkpoint", "")
    challenges = get_challenges()
    challenge_ids = [c["id"] for c in challenges]

    if checkpoint not in challenge_ids:
        return jsonify({"error": f"Unknown challenge: {checkpoint}"}), 400

    idx = challenge_ids.index(checkpoint)
    target = challenges[:idx + 1]

    try:
        subprocess.run(["dropdb", DB_NAME], capture_output=True)
        subprocess.run(["createdb", DB_NAME], capture_output=True)
    except Exception as e:
        return jsonify({"error": f"Failed to reset database: {e}"}), 500

    conn = get_db_connection(timeout=5000)
    conn.autocommit = True
    progress = {}

    try:
        for c in target:
            folder_path = None
            for base in [CHALLENGES_DIR]:
                p = os.path.join(base, c["id"])
                if os.path.isdir(p):
                    folder_path = p
                    break
            if not folder_path:
                continue
            all_sql = ""
            for fname in sorted(os.listdir(folder_path)):
                if fname.endswith(".sql"):
                    with open(os.path.join(folder_path, fname)) as f:
                        all_sql += f.read() + "\n"
            if not all_sql.strip():
                continue
            results = execute_sql(all_sql, conn)
            has_error = any(r["type"] == "error" for r in results)
            if not has_error:
                progress[c["id"]] = True
            else:
                save_progress(progress)
                conn.close()
                return jsonify({
                    "failed_at": c["id"],
                    "error": results[0]["error"],
                    "progress": progress,
                })
            results = execute_sql(all_sql, conn)
            has_error = any(r["type"] == "error" for r in results)
            if not has_error:
                progress[c["id"]] = True
            else:
                save_progress(progress)
                conn.close()
                return jsonify({
                    "failed_at": c["id"],
                    "error": results[0]["error"],
                    "progress": progress,
                })
        conn.close()
    except Exception as e:
        conn.close()
        return jsonify({"error": str(e)}), 500

    save_progress(progress)
    return jsonify({
        "status": "ok",
        "restored_to": checkpoint,
        "progress": progress,
    })


if __name__ == "__main__":
    app.run(debug=True, port=5001)
