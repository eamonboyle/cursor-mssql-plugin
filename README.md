# MSSQL Cursor Plugin

One-stop shop for Microsoft SQL Server development in Cursor: T-SQL rules, skills, agents, commands, hooks, and MCP integration.

## Contents

- **Rules**: T-SQL coding standards, naming conventions, security guidelines
- **Skills**: SQL reviewer, schema explorer, T-SQL optimizer
- **Agents**: Security reviewer, code reviewer
- **Commands**: `/review-sql`, `/explore-schema`, `/deploy-sql`
- **Hooks**: Format T-SQL, validate shell safety, session audit
- **MCP**: mssql-mcp integration for querying and managing your database

## MCP Configuration

This plugin includes [mssql-mcp](https://github.com/eamonboyle/mssql-mcp) for talking to your MSSQL server through Cursor. After installing the plugin, configure your database connection:

1. Edit `mcp.json` (at repo root) or set environment variables before Cursor starts.
2. Required: `SERVER_NAME`, `DATABASE_NAME`, `DB_USER`, `DB_PASSWORD`
3. Optional: `READONLY` (true/false), `DATABASES` (comma-separated for multi-db), `TRUST_SERVER_CERTIFICATE` (true for self-signed certs)

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
        "READONLY": "false"
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
        "READONLY": "false"
      }
    }
  }
}
```

Replace the path with your actual mssql-mcp location. Restart Cursor after changing MCP config.

## Commands

| Command           | Description                                                            |
| ----------------- | ---------------------------------------------------------------------- |
| `/review-sql`     | Review the current SQL file against T-SQL standards and security rules |
| `/explore-schema` | List tables and describe schema via mssql-mcp                          |
| `/deploy-sql`     | Validate and deploy (customize for your pipeline)                      |

## License

MIT
