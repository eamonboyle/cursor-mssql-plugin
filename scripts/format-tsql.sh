#!/usr/bin/env bash
# Formats T-SQL files using poor-mans-t-sql-formatter-cli (via npx).
# Used by hooks/afterFileEdit. On Windows, consider using format-tsql.ps1.
set -euo pipefail

# Read JSON from stdin (Cursor passes file_path) or use $1 as fallback
FILE_PATH="${1:-}"
if [ -z "$FILE_PATH" ] && ! [ -t 0 ]; then
  INPUT=$(cat 2>/dev/null || true)
  if [ -n "$INPUT" ]; then
    FILE_PATH=$(echo "$INPUT" | node -e "
      try {
        const d = JSON.parse(require('fs').readFileSync(0, 'utf8'));
        console.log(d.file_path || d.filePath || '');
      } catch (_) { console.log(''); }
    " 2>/dev/null || true)
  fi
fi

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# Only format .sql files
case "$FILE_PATH" in
  *.sql) ;;
  *) exit 0 ;;
esac

# Try sqlformat (poor-mans-t-sql-formatter-cli) via npx
if command -v npx &>/dev/null; then
  if npx -y poor-mans-t-sql-formatter-cli -f "$FILE_PATH" -g "$FILE_PATH" 2>/dev/null; then
    echo "[cursor-mssql-plugin] format-tsql: formatted $FILE_PATH"
  fi
fi

exit 0
