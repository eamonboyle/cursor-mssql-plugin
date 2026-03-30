# MSSQL Cursor Plugin

One-stop shop for Microsoft SQL Server development in Cursor: T-SQL rules, skills, agents, and MCP integration.

## Contents

- **Rules**: Five `.mdc` rules under `rules/`, including [`project-context.mdc`](rules/project-context.mdc) as the always-on baseline, plus T-SQL coding standards, naming conventions, security guidelines, and data types
- **Skills**: SQL reviewer, schema explorer, T-SQL optimizer, migration writer
- **Agents**: Security reviewer, code reviewer
- **MCP**: mssql-mcp integration for querying and managing your database

## Installation

- **Marketplace:** Install **MSSQL Cursor Plugin** (`cursor-mssql-plugin`) from Cursor’s plugin marketplace (see Cursor’s docs for the current install UI).
- **Local:** Clone or open this repository as the plugin root (folder that contains `.cursor-plugin/`) and enable it as a local plugin per Cursor’s instructions.
- **After install:** Configure the MCP server and database connection in the **[MCP Configuration](#mcp-configuration)** section below and in root [`mcp.json`](mcp.json). Rules, skills, and agents match the repo layout and are discovered automatically.

## MCP Configuration

This plugin wires in **[mssql-mcp](https://github.com/eamonboyle/mssql-mcp)** (`@eamonboyle/mssql-mcp`, **v1.3.x**) so the model can query and manage SQL Server through MCP. Configure after install:

### Safety and behavior (three knobs)

1. **`READONLY`** — `"true"` exposes only read-class tools (schema discovery, `read_data`, `search_data`, `explain_query`, analysis tools, etc.) and hides row writes and DDL. `"false"` allows writes subject to the other settings below. The bundled `mcp.json` uses `"false"`.

2. **`ENABLE_DDL`** — Default `"false"`. DDL tools (`create_table`, `create_index`, `drop_table`) are registered only when `"true"`. Turning on DDL does not override `READONLY`; keep both in mind for least privilege.

3. **`REQUIRE_WRITE_PREVIEW`** — Default `"true"`. For `update_data` and `delete_data`, call `preview_update` / `preview_delete` first, then pass the returned `previewToken` with `confirmed=true` on the matching write. Set to `"false"` to skip the token flow (confirmation rules still apply). Previews and execution respect **`MAX_WRITE_ROWS`**: operations that would affect more rows than the cap are blocked.

For full behavior and error codes, see the upstream [CHANGELOG](https://github.com/eamonboyle/mssql-mcp/blob/main/CHANGELOG.md).

### Setup checklist

1. Edit root `mcp.json` (or your global Cursor MCP config) or export the same variables before starting Cursor.
2. **Required**: `SERVER_NAME`. **`DATABASE_NAME`**: required for single-database setups; optional when `DATABASES` is set (then used as default if listed).
3. **SQL authentication**: `DB_USER` and `DB_PASSWORD` (Windows/integrated auth: see the [mssql](https://www.npmjs.com/package/mssql) driver docs).
4. **Optional — connection / limits**: `DATABASES` (comma-separated allowlist), `READONLY`, `CONNECTION_TIMEOUT` (seconds, default `30`), `QUERY_TIMEOUT_MS` (default `30000`), `MAX_ROWS` (cap for read tools, default `10000`), `TRUST_SERVER_CERTIFICATE` (`"true"` for self-signed / local dev).
5. **Optional — writes / DDL**: `ENABLE_DDL`, `MAX_WRITE_ROWS` (default `100`), `REQUIRE_WRITE_PREVIEW` (default `true`).
6. **Optional — transport**: `MCP_TRANSPORT` (`stdio` default, or `http` for Streamable HTTP), `MCP_HTTP_HOST`, `MCP_HTTP_PORT`, `MCP_BASE_URL` (externally visible base URL when deployed remotely).

Upstream documents one-click install, VS Code `mcp.json` shape, and prompted inputs in the [mssql-mcp README](https://github.com/eamonboyle/mssql-mcp/blob/main/README.md).

### MCP tools (v1.3.x server)

| Tool | Read-only OK | Purpose |
| ---- | ------------ | ------- |
| `read_data` | ✓ | Validated `SELECT` |
| `search_data` | ✓ | Parameterized `LIKE` across columns |
| `explain_query` | ✓ | Estimated plan for a safe `SELECT` |
| `list_table` | ✓ | Tables (items as `{ name: "schema.table" }`) |
| `describe_table` | ✓ | Columns/constraints; optional `schemaName`, `databaseName` |
| `list_objects` | ✓ | Tables, views, procedures, functions, triggers |
| `describe_object` | ✓ | Object definition and metadata |
| `list_databases` | ✓ | Databases visible to the connection |
| `list_foreign_keys` | ✓ | Foreign keys (optional filters) |
| `describe_relationships` | ✓ | Relationship-oriented view of FK graph |
| `analyze_table` | ✓ | Table analysis / summary for safe querying |
| `preview_update` | | Preview rows affected by a structured update |
| `preview_delete` | | Preview rows matched by a structured delete |
| `insert_data` | | Row insert |
| `update_data` / `delete_data` | | Row updates/deletes; pair with preview + token when `REQUIRE_WRITE_PREVIEW=true` |
| `create_table` / `create_index` / `drop_table` | | DDL when `ENABLE_DDL=true` |

### Resources and prompts

Clients that support MCP **resources** / **prompts** get extra discovery: URI templates including `table_schema`, `object_definition`, and **`object_dependencies`**, plus prompts `explore_schema`, `draft_safe_select`, and `review_write_operation`. Details match the published server version (see upstream [CHANGELOG](https://github.com/eamonboyle/mssql-mcp/blob/main/CHANGELOG.md)).

### Cursor HTTP MCP (remote transport)

Run the server with HTTP transport, then point Cursor at the URL:

```bash
MCP_TRANSPORT=http MCP_HTTP_HOST=127.0.0.1 MCP_HTTP_PORT=3333 npx -y @eamonboyle/mssql-mcp
```

Example Cursor config shape (same connection env as usual on the server process; client uses URL):

```json
{
  "mcpServers": {
    "mssql-http": {
      "url": "http://127.0.0.1:3333"
    }
  }
}
```

See upstream README for full HTTP setup and `MCP_BASE_URL` when exposing the server beyond localhost.

### Using the npm package

The bundled `mcp.json` uses `npx -y @eamonboyle/mssql-mcp` with the full set of env keys (empty strings for secrets you fill in locally). Ensure npm publishes **v1.3.0+** of `@eamonboyle/mssql-mcp`, or run from a local build (next section).

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
        "TRUST_SERVER_CERTIFICATE": "false",
        "MCP_TRANSPORT": "stdio",
        "MCP_HTTP_HOST": "127.0.0.1",
        "MCP_HTTP_PORT": "3333",
        "MCP_BASE_URL": "",
        "ENABLE_DDL": "false",
        "MAX_WRITE_ROWS": "100",
        "REQUIRE_WRITE_PREVIEW": "true"
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
        "TRUST_SERVER_CERTIFICATE": "true",
        "MCP_TRANSPORT": "stdio",
        "MCP_HTTP_HOST": "127.0.0.1",
        "MCP_HTTP_PORT": "3333",
        "MCP_BASE_URL": "",
        "ENABLE_DDL": "false",
        "MAX_WRITE_ROWS": "100",
        "REQUIRE_WRITE_PREVIEW": "true"
      }
    }
  }
}
```

Adjust the path to your checkout. Restart Cursor after MCP changes. Use `TRUST_SERVER_CERTIFICATE": "true"` for typical local SQL Server with self-signed TLS.

## License

MIT
