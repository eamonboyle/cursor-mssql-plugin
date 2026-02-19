---
name: deploy-sql
description: Validate SQL, run checks, then deploy. Placeholder flow; user can wire to their pipeline.
---

# Deploy SQL

Validate and deploy SQL changes. Customize this flow to match your deployment pipeline.

## Action

When this command is executed:

1. Run project validation checks (e.g., SQL syntax, schema compatibility).
2. Review the SQL file(s) against T-SQL standards and security rules.
3. Build or prepare artifacts for the target environment.

4. Publish or deploy to the target (staging/production). Replace this step with your actual deployment tool (e.g., sqlpackage, flyway, custom scripts).

5. Run smoke checks and report status.

## Customization

Wire this command to your CI/CD pipeline, sqlpackage, or migration tool. Update the steps above to match your workflow.
