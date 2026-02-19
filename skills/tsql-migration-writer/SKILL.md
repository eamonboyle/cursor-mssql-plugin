---
name: tsql-migration-writer
description: Write idempotent migration scripts for schema changes and versioned deployments. Use when creating migration scripts, altering schema, or preparing versioned releases.
---

# T-SQL Migration Writer

## When to use

- Writing migration scripts for schema changes
- Preparing versioned deployments (e.g. flyway, sqlpackage, custom tooling)
- Adding or altering tables, columns, indexes, constraints
- Refactoring database structure across environments

## Instructions

1. **Idempotent patterns**: Use `IF NOT EXISTS` / `IF EXISTS` so migrations can run safely multiple times.
2. **Transaction wrapping**: Wrap DDL in explicit transactions; roll back on error.
3. **Ordering**: Create dependencies before dependents (e.g. tables before foreign keys, base tables before views).
4. **Rollback**: Document or implement rollback steps where feasible.
5. **Naming**: Use consistent migration naming (e.g. `YYYYMMDD_HHMM_description.sql`).
6. **Schema**: Prefer explicit schema (`[dbo]`) and two-part names.
