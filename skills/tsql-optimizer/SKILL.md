---
name: tsql-optimizer
description: Identify T-SQL performance issues: missing indexes, implicit conversions, scalar UDFs, and NOLOCK misuse. Use when tuning slow queries or reviewing execution plans.
---

# T-SQL Optimizer

## When to use

- When queries are slow or timing out
- When reviewing execution plans
- When adding or modifying indexes
- When refactoring stored procedures for performance

## Instructions

1. **Missing indexes**: Look for WHERE, JOIN, and ORDER BY columns that are not indexed. Suggest covering indexes for frequently filtered columns.
2. **Implicit conversions**: Flag comparisons where column and literal types differ (e.g., `varchar` column compared to `int`), causing index scans.
3. **Scalar UDFs**: Identify user-defined functions in SELECT lists; these prevent parallelism and run row-by-row. Suggest inline TVFs or computed columns where appropriate.
4. **NOLOCK / READ UNCOMMITTED**: Note usage and recommend explicit documentation of dirty-read trade-offs; prefer `READ COMMITTED SNAPSHOT` when applicable.
5. **Large result sets**: Flag SELECT * without TOP or pagination when tables are large.
6. **Temp tables vs table variables**: Recommend temp tables for larger datasets; table variables have no statistics.
