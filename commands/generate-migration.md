---
name: generate-migration
description: Generate an idempotent migration script for schema changes.
---

# Generate Migration

Generate an idempotent migration script for the requested schema change.

## Action

When this command is executed:

1. Understand the schema change the user wants (e.g. add column, create table, add index).
2. If mssql-mcp is configured, use `list_table`, `list_objects`, and `describe_table` / `describe_object` to inspect current schema before generating DDL.
3. Produce idempotent T-SQL using `IF NOT EXISTS` / `IF EXISTS` patterns.
4. Wrap DDL in a transaction where appropriate.
5. Follow T-SQL coding standards and data type guidelines from the project rules.
