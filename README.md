# MSSQL Cursor Plugin

One-stop shop for Microsoft SQL Server development in Cursor: T-SQL rules, skills, agents, and MCP integration.

## Contents

- **Rules**: T-SQL coding standards, naming conventions, security guidelines, data types
- **Skills**: SQL reviewer, schema explorer, T-SQL optimizer, migration writer
- **Agents**: Security reviewer, code reviewer
- **MCP**: mssql-mcp integration for querying and managing your database

## MCP Configuration

This plugin wires in **[mssql-mcp](https://github.com/eamonboyle/mssql-mcp)** (`@eamonboyle/mssql-mcp`) so the model can query and manage SQL Server through MCP. Configure after install:

> **Safety — `READONLY`:** The bundled `mcp.json` sets `READONLY` to `"false"`, so write and DDL MCP tools (insert/update/delete, `create_table`, etc.) are available when credentials allow. For exploration, audits, or when you want the model limited to reads, set `READONLY` to `"true"`; the server then omits those tools. See the tools table below.

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

## License

MIT
