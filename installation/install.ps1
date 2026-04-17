param(
    [string[]]$Tools,
    [switch]$All,
    [switch]$NoReport,
    [switch]$PauseAtEnd
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $PSCommandPath
$DotfilesDir = Split-Path -Parent $ScriptDir
$HelpersPath = Join-Path $ScriptDir "lib\helpers.ps1"

if (-not (Test-Path -LiteralPath $HelpersPath)) {
    throw "Helpers file not found: $HelpersPath"
}

. $HelpersPath
Ensure-RunningAsAdministrator -ScriptPath $PSCommandPath -BoundParameters $PSBoundParameters

$availableTools = @("eza", "starship", "wezterm", "yazi", "zed", "zoxide")

function Show-Usage {
    Write-Host "Dotfiles Windows Installer"
    Write-Host ""
    Write-Host "Usage:"
    Write-Host "  pwsh ./installation/install.ps1 -All"
    Write-Host "  pwsh ./installation/install.ps1 -Tools eza,starship"
    Write-Host ""
    Write-Host "Available tools: $($availableTools -join ', ')"
}

if (-not $All -and (-not $Tools -or $Tools.Count -eq 0)) {
    Show-Usage
    exit 1
}

$toolsToInstall = @()
if ($All) {
    $toolsToInstall = $availableTools
}
else {
    foreach ($tool in $Tools) {
        if ($availableTools -contains $tool) {
            $toolsToInstall += $tool
        }
        else {
            Write-LogWarning "Unknown tool skipped: $tool"
        }
    }
}

if ($toolsToInstall.Count -eq 0) {
    Write-LogError "No valid tools selected."
    Show-Usage
    exit 1
}

$logDir = Join-Path $ScriptDir "logs"
Ensure-Directory -Path $logDir
$transcriptPath = Join-Path $logDir ("install-transcript-{0}.log" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
Start-Transcript -Path $transcriptPath -Force | Out-Null

$exitCode = 0

try {
    Write-LogInfo "Running installer for tools: $($toolsToInstall -join ', ')"

    $results = New-Object System.Collections.Generic.List[object]

    foreach ($tool in $toolsToInstall) {
        $toolScript = Join-Path $ScriptDir "tools\$tool.ps1"
        if (-not (Test-Path -LiteralPath $toolScript)) {
            $results.Add([pscustomobject]@{
                    Tool               = $tool
                    PackageId          = "n/a"
                    Scope              = "machine"
                    Action             = "failed"
                    Status             = "failed"
                    BeforeVersion      = "unknown"
                    AfterVersion       = "unknown"
                    MinRequiredVersion = "n/a"
                    Notes              = @("Installer script missing: $toolScript")
                })
            continue
        }

        try {
            Write-LogInfo "Executing: $tool"
            $result = & $toolScript -DotfilesDir $DotfilesDir -HelpersPath $HelpersPath
            if ($null -eq $result) {
                throw "No result returned by tool script."
            }
            $results.Add($result)
            if ($result.Status -eq "failed") {
                Write-LogError "$tool failed"
            }
            else {
                Write-LogSuccess "$tool $($result.Action)"
            }
        }
        catch {
            $results.Add([pscustomobject]@{
                    Tool               = $tool
                    PackageId          = "n/a"
                    Scope              = "machine"
                    Action             = "failed"
                    Status             = "failed"
                    BeforeVersion      = "unknown"
                    AfterVersion       = "unknown"
                    MinRequiredVersion = "n/a"
                    Notes              = @($_.Exception.Message)
                })
            Write-LogError "$tool failed: $($_.Exception.Message)"
        }
    }

    $summaryPath = Join-Path $logDir ("install-summary-{0}.json" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
    $results | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $summaryPath -Encoding UTF8

    if (-not $NoReport) {
        $reportScript = Join-Path $ScriptDir "report-install-summary.ps1"
        & $reportScript -SummaryPath $summaryPath
    }

    Write-LogInfo "Transcript log: $transcriptPath"
    Write-LogInfo "Summary JSON: $summaryPath"

    $failedCount = ($results | Where-Object { $_.Status -eq "failed" }).Count
    if ($failedCount -gt 0) {
        $exitCode = 1
    }
}
finally {
    Stop-Transcript | Out-Null
}

if ($PauseAtEnd) {
    Read-Host "Press Enter to close"
}

exit $exitCode
