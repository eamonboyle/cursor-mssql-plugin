# MSSQL Cursor Plugin

One-stop shop for Microsoft SQL Server development in Cursor: T-SQL rules, skills, agents, commands, hooks, and MCP integration.

## Contents

- **Rules**: T-SQL coding standards, naming conventions, security guidelines, data types
- **Skills**: SQL reviewer, schema explorer, T-SQL optimizer, migration writer
- **Agents**: Security reviewer, code reviewer
- **Commands**: `/review-sql`, `/explore-schema`, `/deploy-sql`, `/generate-migration`
- **Hooks**: Format T-SQL, validate shell safety, session audit
- **MCP**: mssql-mcp integration for querying and managing your database

## MCP Configuration

This plugin wires in **[mssql-mcp](https://github.com/eamonboyle/mssql-mcp)** (`@eamonboyle/mssql-mcp`) so the model can query and manage SQL Server through MCP. Configure after install:

1. Edit root `mcp.json` (or your global Cursor MCP config) or export the same variables before starting Cursor.
2. **Required**: `SERVER_NAME`. **`DATABASE_NAME`**: required for single-database setups; optional when `DATABASES` is set (then used as default if listed).
3. **SQL authentication**: `DB_USER` and `DB_PASSWORD` (Windows/integrated auth: see the [mssql](https://www.npmjs.com/package/mssql) driver docs).
4. **Optional**: `DATABASES` (comma-separated allowlist), `READONLY` (`"true"` hides write/DDL tools), `CONNECTION_TIMEOUT` (seconds, default `30`), `QUERY_TIMEOUT_MS` (default `30000`), `MAX_ROWS` (cap for read tools, default `10000`), `TRUST_SERVER_CERTIFICATE` (`"true"` for self-signed / local dev).

Upstream documents one-click install, VS Code `mcp.json` shape, and prompted inputs in the [mssql-mcp README](https://github.com/eamonboyle/mssql-mcp/blob/main/README.md).

### MCP tools (current server)

| Tool | Read-only OK | Purpose |
| ---- | ------------ | ------- |
| `read_data` | ✓ | Validated `SELECT` |
| `search_data` | ✓ | Parameterized `LIKE` across columns |
| `explain_query` | ✓ | Estimated plan for a safe `SELECT` |
| `list_table` | ✓ | Tables (items as `{ name: "schema.table" }`) |
| `describe_table` | ✓ | Columns/constraints; optional `schemaName`, `databaseName` |
| `list_objects` | ✓ | Tables, views, procedures, functions, triggers |
| `describe_object` | ✓ | Object definition and metadata |
| `insert_data` / `update_data` / `delete_data` | | Row CRUD (`update`/`delete` require structured filters) |
| `create_table` / `create_index` / `drop_table` | | DDL |

### Resources and prompts

Clients that support MCP **resources** / **prompts** get extra discovery: e.g. `table_schema` and `object_definition` URI templates, plus prompts `explore_schema`, `draft_safe_select`, and `review_write_operation`. Details match the published server version (see upstream [CHANGELOG](https://github.com/eamonboyle/mssql-mcp/blob/main/CHANGELOG.md)).

### Using the npm package

The bundled `mcp.json` uses `npx -y @eamonboyle/mssql-mcp` with the full set of env keys (empty strings for secrets you fill in locally):

```json
{
  "mcpServers": {
    "mssql": {
      "command": "npx",
      "args": ["-y", "@eamonboyle/mssql-mcp"],
      "env": {
        "SERVER_NAME": "localhost",
        "DATABASE_NAME": "YourDatabase",
        "DATABASES": "",
        "DB_USER": "your_username",
        "DB_PASSWORD": "your_password",
        "READONLY": "false",
        "CONNECTION_TIMEOUT": "30",
        "QUERY_TIMEOUT_MS": "30000",
        "MAX_ROWS": "10000",
        "TRUST_SERVER_CERTIFICATE": "false"
      }
    }
  }
}
```

### Local development (mssql-mcp source)

If you develop mssql-mcp alongside this plugin, point `command` / `args` at your built `dist/index.js`:

```json
{
  "mcpServers": {
    "mssql": {
      "command": "node",
      "args": ["D:/code/opensource/mssql-mcp/dist/index.js"],
      "env": {
        "SERVER_NAME": "localhost",
        "DATABASE_NAME": "YourDatabase",
        "DATABASES": "",
        "DB_USER": "",
        "DB_PASSWORD": "",
        "READONLY": "false",
        "CONNECTION_TIMEOUT": "30",
        "QUERY_TIMEOUT_MS": "30000",
        "MAX_ROWS": "10000",
        "TRUST_SERVER_CERTIFICATE": "true"
      }
    }
  }
}
```

Adjust the path to your checkout. Restart Cursor after MCP changes. Use `TRUST_SERVER_CERTIFICATE": "true"` for typical local SQL Server with self-signed TLS.

## Platform notes

### Hooks (Windows)

The default hooks use `.sh` scripts, which require Git Bash or WSL on Windows. To use PowerShell instead, edit your local hooks config to point to the `.ps1` scripts:

- `./scripts/format-tsql.ps1`
- `./scripts/validate-sql-safety.ps1`
- `./scripts/audit-sql-changes.ps1`

### Hooks behavior

- **format-tsql**: Formats `.sql` files after edit using [poor-mans-t-sql-formatter-cli](https://github.com/TaoK/poor-mans-t-sql-formatter-npm-cli) via `npx`. Requires Node.js.
- **validate-sql-safety**: Blocks `DROP DATABASE`, `TRUNCATE TABLE`, and `rm -rf /`; warns on `DROP TABLE`. Allows other commands.
- **audit-sql-changes**: Appends session-end timestamps to `.cursor/mssql-audit.log`.

## Commands

| Command               | Description                                                            |
| --------------------- | ---------------------------------------------------------------------- |
| `/review-sql`         | Review the current SQL file against T-SQL standards and security rules |
| `/explore-schema`     | Explore schema via mssql-mcp (`list_table`, `list_objects`, `describe_*`) |
| `/deploy-sql`         | Validate and deploy (customize for your pipeline)                      |
| `/generate-migration` | Generate an idempotent migration script for schema changes             |

## License

MIT
