param(
    [Parameter(Mandatory = $true)][string]$DotfilesDir,
    [Parameter(Mandatory = $true)][string]$HelpersPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. $HelpersPath

$tool = "glazewm"
$packageId = "glzr-io.glazewm"
$binary = "glazewm"

$result = [ordered]@{
    Tool               = $tool
    PackageId          = $packageId
    Scope              = "machine"
    Action             = "none"
    Status             = "failed"
    BeforeVersion      = "unknown"
    AfterVersion       = "unknown"
    VersionSource      = "unknown"
    MinRequiredVersion = "n/a"
    ZebarStatus        = "unknown"
    ZebarVersion       = "unknown"
    Notes              = @()
}

try {
    $installResult = Install-WingetPackageWithPolicy -PackageId $packageId -ToolName $tool -CommandName $binary
    $result.BeforeVersion = $installResult.DetectedBeforeVersion
    $result.AfterVersion = $installResult.DetectedAfterVersion
    $result.VersionSource = $installResult.VersionSource
    $result.Action = $installResult.Action
    $result.MinRequiredVersion = $installResult.MinRequiredVersion
    if (-not $installResult.Success) {
        throw $installResult.Message
    }

    $source = Join-Path $DotfilesDir "glazewm"
    $target = Join-Path $HOME ".config\glazewm"
    Set-SymlinkSafely -Source $source -Target $target

    $zebarSource = Join-Path $source "zebar"
    Ensure-Directory -Path $zebarSource
    $zebarTarget = Join-Path $HOME ".glzr\zebar"

    if (Test-Path -LiteralPath $zebarTarget) {
        $zebarTargetItem = Get-Item -LiteralPath $zebarTarget -Force
        if (-not $zebarTargetItem.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
            Get-ChildItem -LiteralPath $zebarTarget -Force | ForEach-Object {
                Move-Item -LiteralPath $_.FullName -Destination $zebarSource -Force
            }
            $result.Notes += "Migrated existing Zebar files from $zebarTarget into $zebarSource"
        }
    }

    Set-SymlinkSafely -Source $zebarSource -Target $zebarTarget

    $zebarDetected = Get-EffectiveInstalledVersion -PackageId "glzr-io.zebar" -ToolName "zebar" -CommandName "zebar"
    if ($zebarDetected.Source -eq "unknown" -or [string]::IsNullOrWhiteSpace($zebarDetected.Version) -or $zebarDetected.Version -eq "unknown") {
        $result.ZebarStatus = "not-installed"
        $result.ZebarVersion = "unknown"
        $result.Notes += "Zebar not detected after GlazeWM install."
    }
    else {
        $result.ZebarStatus = "installed"
        $result.ZebarVersion = $zebarDetected.Version
        $result.Notes += "Zebar detected after GlazeWM install: $($zebarDetected.Version)"
    }

    $configPath = Join-Path $target "config.yaml"
    [Environment]::SetEnvironmentVariable("GLAZEWM_CONFIG_PATH", $configPath, "User")
    $env:GLAZEWM_CONFIG_PATH = $configPath

    $result.Status = "ok"
    $result.Notes += $installResult.Message
    $result.Notes += "Linked GlazeWM config directory to $target"
    $result.Notes += "Linked Zebar config directory to $zebarTarget"
    $result.Notes += "Set user environment variable GLAZEWM_CONFIG_PATH=$configPath"
}
catch {
    $result.Action = "failed"
    $result.Status = "failed"
    $result.Notes += $_.Exception.Message
}
finally {
    if ([string]::IsNullOrWhiteSpace($result.AfterVersion)) {
        $result.AfterVersion = $result.BeforeVersion
    }

    if ([string]::IsNullOrWhiteSpace($result.AfterVersion)) {
        $result.AfterVersion = "unknown"
    }

    if ([string]::IsNullOrWhiteSpace($result.VersionSource)) {
        $result.VersionSource = "unknown"
    }

    if ([string]::IsNullOrWhiteSpace($result.ZebarStatus)) {
        $result.ZebarStatus = "unknown"
    }

    if ([string]::IsNullOrWhiteSpace($result.ZebarVersion)) {
        $result.ZebarVersion = "unknown"
    }
}

[pscustomobject]$result
