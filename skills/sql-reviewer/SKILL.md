---
name: sql-reviewer
description: Review T-SQL for correctness, performance, security, and style compliance. Use when preparing a PR, auditing SQL changes, or validating stored procedures.
---

# SQL Reviewer

## When to use

- Before opening a pull request with SQL changes
- After writing or modifying stored procedures, views, or scripts
- When validating risky DML or DDL changes
- When reviewing migration scripts

## Instructions

1. **Correctness**: Identify logic errors, missing NULL handling, and incorrect join conditions.
2. **Performance**: Flag missing indexes on filtered/joined columns, N+1 patterns, implicit conversions, and scalar UDFs in SELECT lists.
3. **Security**: Check for SQL injection risks, dynamic SQL without validation, and overly broad permissions.
4. **Style**: Verify alignment with T-SQL coding standards (semicolons, naming, `TRY...CATCH`, `THROW` vs `RAISERROR`).
5. **Recommendations**: Provide concrete fixes with minimal churn; call out missing tests or validation steps where relevant.
