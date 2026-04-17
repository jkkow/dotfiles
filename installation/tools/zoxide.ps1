param(
    [Parameter(Mandatory = $true)][string]$DotfilesDir,
    [Parameter(Mandatory = $true)][string]$HelpersPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. $HelpersPath

$tool = "zoxide"
$packageId = "ajeetdsouza.zoxide"
$binary = "zoxide"

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

    $result.AfterVersion = Get-CommandSemanticVersion -CommandName $binary
    $result.Status = "ok"
    $result.Notes += $installResult.Message
    $result.Notes += "zoxide installation completed"
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
