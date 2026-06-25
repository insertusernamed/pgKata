# pgKata

PostgreSQL challenge platform that runs entirely in your browser.

## Challenges

58 challenges across 9 tiers.

| Tier | Topic | Challenges |
|------|-------|-----------|
| 01 | SQL Foundations | 12 |
| 02 | Joins & Relationships | 5 |
| 03 | Aggregation | 6 |
| 04 | Subqueries & CTEs | 6 |
| 05 | Window Functions | 6 |
| 06 | PostgreSQL Specialties | 7 |
| 07 | PL/pgSQL | 5 |
| 08 | Expert PostgreSQL | 6 |
| 09 | LeetCode Practice | 5 |

Covers SELECT, JOIN, GROUP BY, subqueries, window functions, JSONB, arrays, full-text search, enums, PL/pgSQL functions, stored procedures, triggers, recursive CTEs, isolation levels, row-level security, and query planning.

## Features

- **CodeMirror editor** with PostgreSQL syntax highlighting and schema-aware autocomplete.
- **Run**: execute SQL against the in-browser Postgres. Results render as tables.
- **Verify**: check your solution against expected output with column and row diff.
- **Hints**: progressive hints per challenge.
- **psql bar**: `\dt`, `\d`, `\l`, `\df`, `\du`, `\dn`, `\di`, `\dv`, `\conninfo`, raw SQL.
- **Restore**: reset the database and replay all setup SQL up to a chosen checkpoint.
- **Auto-save**: editor content persists to localStorage. Progress persists across visits.
- **Indent controls**: spaces or tabs, configurable width.

## How it works

[PGlite](https://github.com/electric-sql/pglite) is a full PostgreSQL compiled to WebAssembly. It runs inside the page, no server needed. The database persists to IndexedDB across sessions.

The page is a single HTML file with no build step. PGlite and CodeMirror load from CDN. Challenge files are fetched as static JSON and SQL.
