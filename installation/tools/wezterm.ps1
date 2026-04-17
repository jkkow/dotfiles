param(
    [Parameter(Mandatory = $true)][string]$DotfilesDir,
    [Parameter(Mandatory = $true)][string]$HelpersPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. $HelpersPath

$tool = "wezterm"
$packageId = "wez.wezterm.nightly"
$binary = "wezterm"

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

    $source = Join-Path $DotfilesDir "wezterm"
    $target = Join-Path $HOME ".config\wezterm"
    Set-SymlinkSafely -Source $source -Target $target
    $result.Status = "ok"
    $result.Notes += "Using WezTerm nightly channel by default for minimum version compatibility."
    $result.Notes += $installResult.Message
    $result.Notes += "Linked WezTerm config directory to $target"
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
}

[pscustomobject]$result
