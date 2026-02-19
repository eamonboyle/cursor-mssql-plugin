---
name: review-sql
description: Review the current/open SQL file against T-SQL standards and security rules.
---

# Review SQL

Review the currently open SQL file against T-SQL coding standards, naming conventions, and security guidelines.

## Action

When this command is executed:

1. Identify the currently open SQL file from the editor context.
2. Read and analyze the SQL content for:
   - Correctness (logic, NULL handling, joins)
   - Style (semicolons, naming, `TRY...CATCH`, `THROW`)
   - Performance (indexes, implicit conversions, scalar UDFs, NOLOCK)
   - Security (parameterization, dynamic SQL, credentials)
3. Provide a structured review with findings and concrete recommendations.
4. Prioritize high-impact issues first.
