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
    Tool          = $tool
    PackageId     = $packageId
    Scope         = "machine"
    Action        = "none"
    Status        = "failed"
    BeforeVersion = "not-installed"
    AfterVersion  = "not-installed"
    MinRequiredVersion = "n/a"
    Notes         = @()
}

try {
    $result.BeforeVersion = Get-CommandSemanticVersion -CommandName $binary
    $installResult = Install-WingetPackageWithPolicy -PackageId $packageId -ToolName $tool -CommandName $binary
    $result.Action = $installResult.Action
    $result.MinRequiredVersion = $installResult.MinRequiredVersion
    if (-not $installResult.Success) {
        throw $installResult.Message
    }

    $source = Join-Path $DotfilesDir "wezterm"
    $target = Join-Path $HOME ".config\wezterm"
    Set-SymlinkSafely -Source $source -Target $target

    $result.AfterVersion = Get-CommandSemanticVersion -CommandName $binary
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
    $result.AfterVersion = Get-CommandSemanticVersion -CommandName $binary
}

[pscustomobject]$result
