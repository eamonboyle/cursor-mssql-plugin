---
name: mssql-schema-explorer
description: Use mssql-mcp tools to explore database schema before writing queries. Use when you need to understand table structure, columns, or relationships.
---

# MSSQL Schema Explorer

## When to use

- Before writing new queries or stored procedures
- When refactoring or modifying existing schema
- When debugging query issues and need to verify column types or constraints
- When documenting database structure

## Instructions

1. **List tables**: Use the `list_table` MCP tool to see available tables in the database. Optionally pass `databaseName` for multi-database setups.
2. **Describe table**: Use the `describe_table` MCP tool with a table name to get column names, types, and constraints.
3. **Read sample data**: Use the `read_data` MCP tool with a SELECT query to inspect sample rows when needed.
4. **Workflow**: Always explore schema before writing complex queries. Call `list_table` first, then `describe_table` for each relevant table.

## Prerequisites

The mssql-mcp server must be configured and connected. Ensure `SERVER_NAME`, `DATABASE_NAME`, and credentials are set in the MCP config.
