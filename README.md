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

This plugin includes [mssql-mcp](https://github.com/eamonboyle/mssql-mcp) for talking to your MSSQL server through Cursor. After installing the plugin, configure your database connection:

1. Edit `mcp.json` at repo root (or your Cursor config location if installed from marketplace) or set environment variables before Cursor starts.
2. Required: `SERVER_NAME`, `DATABASE_NAME`, `DB_USER`, `DB_PASSWORD`
3. Optional: `READONLY` (true/false), `DATABASES` (comma-separated for multi-db), `TRUST_SERVER_CERTIFICATE` (true for self-signed certs, e.g. local SQL Server)

### Using the npm package

The default config uses `npx -y @eamonboyle/mssql-mcp`. Set env vars or edit `mcp.json`:

```json
{
  "mcpServers": {
    "mssql": {
      "command": "npx",
      "args": ["-y", "@eamonboyle/mssql-mcp"],
      "env": {
        "SERVER_NAME": "localhost",
        "DATABASE_NAME": "YourDatabase",
        "DB_USER": "your_username",
        "DB_PASSWORD": "your_password",
        "READONLY": "false",
        "TRUST_SERVER_CERTIFICATE": "true"
      }
    }
  }
}
```

### Local development (mssql-mcp source)

If you develop mssql-mcp alongside this plugin, override the command to use the local build:

```json
{
  "mcpServers": {
    "mssql": {
      "command": "node",
      "args": ["D:/code/mssql-mcp/dist/index.js"],
      "env": {
        "SERVER_NAME": "localhost",
        "DATABASE_NAME": "YourDatabase",
        "DB_USER": "",
        "DB_PASSWORD": "",
        "READONLY": "false",
        "TRUST_SERVER_CERTIFICATE": "true"
      }
    }
  }
}
```

Replace the path with your actual mssql-mcp location. Restart Cursor after changing MCP config. Set `TRUST_SERVER_CERTIFICATE` to `"true"` for local SQL Server with self-signed certs.

## Platform notes

### Hooks (Windows)

The default hooks use `.sh` scripts, which require Git Bash or WSL on Windows. To use PowerShell instead, edit your local hooks config to point to the `.ps1` scripts:

- `./scripts/format-tsql.ps1`
- `./scripts/validate-sql-safety.ps1`
- `./scripts/audit-sql-changes.ps1`

## Commands

| Command               | Description                                                            |
| --------------------- | ---------------------------------------------------------------------- |
| `/review-sql`         | Review the current SQL file against T-SQL standards and security rules |
| `/explore-schema`     | List tables and describe schema via mssql-mcp                          |
| `/deploy-sql`         | Validate and deploy (customize for your pipeline)                      |
| `/generate-migration` | Generate an idempotent migration script for schema changes             |

## License

MIT
