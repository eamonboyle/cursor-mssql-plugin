# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [0.3.0] - 2026-03-30

### Changed

- **MCP**: Aligned docs and sample `mcp.json` with [mssql-mcp](https://github.com/eamonboyle/mssql-mcp) **v1.3.x** — new tools (`list_databases`, `list_foreign_keys`, `describe_relationships`, `analyze_table`, `preview_update`, `preview_delete`), env vars (`MCP_TRANSPORT`, `MCP_HTTP_HOST`, `MCP_HTTP_PORT`, `MCP_BASE_URL`, `ENABLE_DDL`, `MAX_WRITE_ROWS`, `REQUIRE_WRITE_PREVIEW`), DDL gating, write-preview workflow for `update_data` / `delete_data`, resource template `object_dependencies`, and Cursor HTTP MCP notes.
- **`mssql-schema-explorer` skill**: Steps for analysis/relationship tools and preview-before-write for destructive updates/deletes.
- **`project-context` rule**: Documents `ENABLE_DDL`, `REQUIRE_WRITE_PREVIEW`, and DDL availability.
- **Plugin manifest**: Version **0.3.0**.

## [0.2.0] - 2026-03-27

### Changed

- **MCP**: Aligned docs and sample `mcp.json` with [mssql-mcp](https://github.com/eamonboyle/mssql-mcp) v1.2.x — env vars (`DATABASES`, `CONNECTION_TIMEOUT`, `QUERY_TIMEOUT_MS`, `MAX_ROWS`, `TRUST_SERVER_CERTIFICATE`), tool inventory (including `list_objects`, `describe_object`, `search_data`, `explain_query`, `delete_data`), resources/prompts, and schema-first / read-only behavior.
- **`mssql-schema-explorer` skill**: Updated steps and prerequisites for the expanded tool surface.
- **`project-context` rule**: Reflects current MCP workflow and configuration knobs.
- **Plugin manifest**: Version **0.2.0**.

### Removed

- **Commands** and **hooks** as bundled plugin components (use skills/agents and your own local automation instead).
- **Hook helper scripts** (`format-tsql`, `validate-sql-safety`, `audit-sql-changes` — `.sh` / `.ps1`).

## [0.1.0] - 2025-02-19

### Added

- **Rules**: T-SQL coding standards, naming conventions, security guidelines, project context, data types
- **Skills**: SQL reviewer, schema explorer, T-SQL optimizer, migration writer
- **Agents**: Security reviewer, code reviewer
- **Commands**: `/review-sql`, `/explore-schema`, `/deploy-sql`, `/generate-migration`
- **Hooks**: Format T-SQL, validate shell safety, session audit (placeholders; bash and PowerShell)
- **MCP**: mssql-mcp integration for querying and managing MSSQL databases
- **LICENSE**: MIT
