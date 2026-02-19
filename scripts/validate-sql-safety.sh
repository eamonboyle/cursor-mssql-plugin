#!/usr/bin/env bash
# Validates shell commands for risky SQL-related patterns.
# Blocks dangerous commands (exit 2); allows others with optional warning (exit 0).
# Used by hooks/beforeShellExecution. On Windows, consider using validate-sql-safety.ps1.
set -euo pipefail

# Read JSON from stdin (Cursor passes command, etc.) or use $COMMAND env / $1
COMMAND_STR=""
if [ -n "${COMMAND:-}" ]; then
  COMMAND_STR="$COMMAND"
elif [ -n "${1:-}" ]; then
  COMMAND_STR="$1"
elif ! [ -t 0 ]; then
  INPUT=$(cat 2>/dev/null || true)
  if [ -n "$INPUT" ]; then
    COMMAND_STR=$(echo "$INPUT" | node -e "
      try {
        const d = JSON.parse(require('fs').readFileSync(0, 'utf8'));
        console.log(d.command || '');
      } catch (_) { console.log(''); }
    " 2>/dev/null || true)
  fi
fi

# Output JSON for Cursor hook protocol
output_allow() {
  echo '{"decision": "allow"}'
  exit 0
}

output_deny() {
  echo "{\"decision\": \"deny\", \"reason\": \"$1\"}"
  exit 2
}

if [ -z "$COMMAND_STR" ]; then
  output_allow
fi

# Block: DROP DATABASE (without backup context)
if echo "$COMMAND_STR" | grep -qiE 'DROP\s+DATABASE'; then
  output_deny "DROP DATABASE is blocked. Use with extreme caution in production."
fi

# Block: TRUNCATE without clear safety intent (e.g. in sqlcmd)
if echo "$COMMAND_STR" | grep -qiE 'TRUNCATE\s+TABLE'; then
  output_deny "TRUNCATE TABLE is blocked. Verify data loss is intended."
fi

# Block: rm -rf / or similar
if echo "$COMMAND_STR" | grep -qE 'rm\s+-rf\s+/'; then
  output_deny "Recursive rm on root is blocked."
fi

# Allow with warning: DROP TABLE (user may intend it)
if echo "$COMMAND_STR" | grep -qiE 'DROP\s+TABLE'; then
  echo '{"decision": "allow", "agentMessage": "Warning: DROP TABLE will permanently delete data. Ensure you have backups."}'
  exit 0
fi

output_allow
