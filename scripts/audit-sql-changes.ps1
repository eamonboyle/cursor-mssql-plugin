# Session-end audit: appends timestamp and optional session info to .cursor/mssql-audit.log.
# Used by hooks/sessionEnd when running on Windows.
$ErrorActionPreference = "SilentlyContinue"

$root = if ($env:CURSOR_WORKSPACE_ROOT) { $env:CURSOR_WORKSPACE_ROOT } else { Get-Location }
$auditDir = Join-Path $root ".cursor"
$auditLog = Join-Path $auditDir "mssql-audit.log"

if (-not (Test-Path $auditDir)) { New-Item -ItemType Directory -Path $auditDir -Force | Out-Null }

$sessionInfo = ""
try {
  $input = [System.Console]::In.ReadToEnd()
  if ($input) { $sessionInfo = $input.Trim() }
} catch {}

$timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
$line = if ($sessionInfo) { "$timestamp session_end $sessionInfo" } else { "$timestamp session_end" }
Add-Content -Path $auditLog -Value $line

exit 0
