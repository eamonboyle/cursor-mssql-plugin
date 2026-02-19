# Formats T-SQL files using poor-mans-t-sql-formatter-cli (via npx).
# Used by hooks/afterFileEdit when running on Windows.
$ErrorActionPreference = "SilentlyContinue"

$filePath = $args[0]
if (-not $filePath -and $env:CI -ne "true") {
  try {
    $input = [System.Console]::In.ReadToEnd()
    if ($input) {
      $json = $input | ConvertFrom-Json
      $filePath = if ($json.file_path) { $json.file_path } else { $json.filePath }
    }
  } catch {}
}

if (-not $filePath -or -not (Test-Path $filePath)) { exit 0 }
if (-not $filePath.EndsWith(".sql")) { exit 0 }

if (Get-Command npx -ErrorAction SilentlyContinue) {
  $null = npx -y poor-mans-t-sql-formatter-cli -f $filePath -g $filePath 2>$null
  if ($LASTEXITCODE -eq 0) {
    Write-Host "[cursor-mssql-plugin] format-tsql: formatted $filePath"
  }
}
exit 0
