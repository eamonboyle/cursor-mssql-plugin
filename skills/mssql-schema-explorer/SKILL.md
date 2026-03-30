---
name: mssql-schema-explorer
description: Use mssql-mcp tools to explore SQL Server schema before writing queries. Use when you need tables, views, routines, column details, or safe reads.
---

# MSSQL Schema Explorer

## When to use

- Before writing new queries or stored procedures
- When refactoring or modifying existing schema
- When debugging query issues and need to verify column types or constraints
- When documenting database structure or locating views/procs/triggers

## Instructions

1. **Schema first**: Prefer listing and describing before `read_data`. When `READONLY=true` on the server, only read-class tools are available.
2. **Databases**: `list_databases` when you need to confirm which databases are reachable or pick a `databaseName` for later calls.
3. **List tables**: `list_table` — optional `parameters` (schema names), `databaseName`. Results use `{ name: "schema.table" }` entries.
4. **Broader discovery**: `list_objects` — optional `objectTypes` (`table`, `view`, `procedure`, `function`, `trigger`), `schemaName`, `databaseName`.
5. **Table shape**: `describe_table` — `tableName`, optional `schemaName`, `databaseName`.
6. **Relationships**: Prefer `describe_relationships` or `list_foreign_keys` when modeling joins, cascades, or impact of changes; use `analyze_table` for a summarized view before heavy reads or writes.
7. **Views/procs/etc.**: `describe_object` — `objectName`, optional `objectTypes`, `schemaName`, `databaseName`.
8. **Search rows**: `search_data` — parameterized `LIKE` across named columns (good alternative to hand-written `SELECT` for exploration).
9. **Plans**: `explain_query` — estimated plan for a `SELECT` that passes the same guards as `read_data`.
10. **Sample rows**: `read_data` only after you know table/column names; keep queries minimal and respect `MAX_ROWS`.
11. **Destructive writes**: Before `update_data` or `delete_data`, run `preview_update` or `preview_delete` when `REQUIRE_WRITE_PREVIEW` is enabled (default); use the returned `previewToken` with `confirmed=true` on the matching write. Respect `MAX_WRITE_ROWS`.
12. On clients that support MCP resources/prompts, use `explore_schema` / `draft_safe_select` and table/object/**dependency** resources when offered.

## Prerequisites

mssql-mcp must be configured: at minimum `SERVER_NAME`; `DATABASE_NAME` or `DATABASES`; credentials for SQL auth unless using integrated auth per the driver. See repo `README.md` and [upstream docs](https://github.com/eamonboyle/mssql-mcp).
