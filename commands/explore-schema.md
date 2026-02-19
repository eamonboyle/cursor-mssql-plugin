---
name: explore-schema
description: Use mssql-mcp to list tables and describe schema for the current database context.
---

# Explore Schema

Use the mssql-mcp MCP server to explore the database schema.

## Action

When this command is executed:

1. Call the `list_table` MCP tool to list all tables in the database.
2. If the user has a specific table in context, call `describe_table` for that table.
3. Otherwise, present the table list and offer to describe any table.
4. If mssql-mcp is not configured, instruct the user to set `SERVER_NAME`, `DATABASE_NAME`, `DB_USER`, and `DB_PASSWORD` in the MCP config.
