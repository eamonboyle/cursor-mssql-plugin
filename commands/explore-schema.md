---
name: explore-schema
description: Use mssql-mcp to list schema objects and describe tables/views/routines for the current database context.
---

# Explore Schema

Use the mssql-mcp MCP server with a **schema-first** workflow (list → describe → read/search/explain).

## Action

When this command is executed:

1. Call `list_table` (and/or `list_objects` if views/procedures matter) for the relevant `databaseName` when using multi-database config.
2. If the user names a table, call `describe_table` with optional `schemaName` when the table is not in the default schema.
3. For views, procedures, functions, or triggers, use `describe_object` with appropriate `objectTypes` if needed.
4. Optionally use `search_data` or a narrow `read_data` query for sample rows after structure is clear; use `explain_query` if the user asks why a query might be slow.
5. Present results clearly (remember `list_table` returns `schema.table`-style names).
6. If mssql-mcp is not configured, tell the user to set `SERVER_NAME`, credentials, and either `DATABASE_NAME` or `DATABASES` in MCP config (see plugin `README.md`).
