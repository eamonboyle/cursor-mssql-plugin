# Validates shell commands for risky SQL-related patterns.
# Blocks dangerous commands (exit 2); allows others with optional warning (exit 0).
# Used by hooks/beforeShellExecution when running on Windows.
$ErrorActionPreference = "SilentlyContinue"

$commandStr = $env:COMMAND
if (-not $commandStr -and $args[0]) { $commandStr = $args[0] }
if (-not $commandStr) {
  try {
    $input = [System.Console]::In.ReadToEnd()
    if ($input) {
      $json = $input | ConvertFrom-Json
      $commandStr = $json.command
    }
  } catch {}
}

function Output-Allow { Write-Output '{"decision": "allow"}'; exit 0 }
function Output-Deny($reason) { Write-Output "{`"decision`": `"deny`", `"reason`": `"$reason`"}"; exit 2 }

if (-not $commandStr) { Output-Allow }

$cmd = $commandStr.ToUpper()

if ($cmd -match 'DROP\s+DATABASE') {
  Output-Deny "DROP DATABASE is blocked. Use with extreme caution in production."
}
if ($cmd -match 'TRUNCATE\s+TABLE') {
  Output-Deny "TRUNCATE TABLE is blocked. Verify data loss is intended."
}
if ($commandStr -match 'rm\s+-rf\s+/') {
  Output-Deny "Recursive rm on root is blocked."
}
if ($cmd -match 'DROP\s+TABLE') {
  Write-Output '{"decision": "allow", "agentMessage": "Warning: DROP TABLE will permanently delete data. Ensure you have backups."}'
  exit 0
}

Output-Allow
