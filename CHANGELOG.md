# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

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
