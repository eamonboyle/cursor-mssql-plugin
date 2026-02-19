#!/usr/bin/env bash
# Session-end audit: appends timestamp and optional session info to .cursor/mssql-audit.log.
# Used by hooks/sessionEnd. On Windows, consider using audit-sql-changes.ps1.
set -euo pipefail

AUDIT_LOG="${CURSOR_WORKSPACE_ROOT:-.}/.cursor/mssql-audit.log"
mkdir -p "$(dirname "$AUDIT_LOG")"

# Read JSON from stdin if available (session info)
SESSION_INFO=""
if ! [ -t 0 ]; then
  SESSION_INFO=$(cat 2>/dev/null || true)
fi

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date +"%Y-%m-%dT%H:%M:%S" 2>/dev/null || echo "unknown")
if [ -n "$SESSION_INFO" ]; then
  echo "$TIMESTAMP session_end $SESSION_INFO" >> "$AUDIT_LOG"
else
  echo "$TIMESTAMP session_end" >> "$AUDIT_LOG"
fi

exit 0
