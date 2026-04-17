param(
    [Parameter(Mandatory = $true)][string]$SummaryPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $SummaryPath)) {
    throw "Summary file not found: $SummaryPath"
}

$raw = Get-Content -LiteralPath $SummaryPath -Raw
$results = $raw | ConvertFrom-Json

if ($results -isnot [System.Array]) {
    $results = @($results)
}

Write-Host ""
Write-Host "Installation Summary" -ForegroundColor Cyan
$results |
Select-Object Tool, PackageId, Action, Status, @{
        Name       = "InstalledVersion"
        Expression = {
            if (-not [string]::IsNullOrWhiteSpace($_.AfterVersion)) {
                return $_.AfterVersion
            }

            if (-not [string]::IsNullOrWhiteSpace($_.BeforeVersion)) {
                return $_.BeforeVersion
            }

            return "unknown"
        }
    }, MinRequiredVersion, @{
        Name       = "VersionSource"
        Expression = {
            if (-not [string]::IsNullOrWhiteSpace($_.VersionSource)) {
                return $_.VersionSource
            }

            return "unknown"
        }
    }, Scope |
Format-Table -AutoSize

$installed = @($results | Where-Object { $_.Action -eq "installed" }).Count
$updated = @($results | Where-Object { $_.Action -eq "updated" }).Count
$skipped = @($results | Where-Object { $_.Action -eq "skipped" }).Count
$failed = @($results | Where-Object { $_.Status -eq "failed" }).Count

Write-Host ""
Write-Host "Totals: installed=$installed updated=$updated skipped=$skipped failed=$failed" -ForegroundColor Cyan
Write-Host "JSON report: $SummaryPath" -ForegroundColor DarkCyan
