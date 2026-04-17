param(
    [Parameter(Mandatory = $true)][string]$DotfilesDir,
    [Parameter(Mandatory = $true)][string]$HelpersPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. $HelpersPath

$tool = "eza"
$packageId = "eza-community.eza"
$binary = "eza"

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

    $source = Join-Path $DotfilesDir "eza\themes\tokyonight.yml"
    $configDir = Join-Path $HOME ".config\eza"
    $target = Join-Path $configDir "theme.yml"

    if (Test-Path -LiteralPath $configDir) {
        $configItem = Get-Item -LiteralPath $configDir -Force
        if (-not $configItem.PSIsContainer) {
            throw "Expected eza config directory but found a file: $configDir"
        }

        if ($configItem.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
            $timestamp = Get-Date -Format "yyyyMMddHHmmss"
            $backupPath = "$configDir.bak.$timestamp"
            Move-Item -LiteralPath $configDir -Destination $backupPath -Force
            $result.Notes += "Backed up linked eza config directory to $backupPath to enforce file-level linking."
        }
    }

    New-Item -ItemType Directory -Path $configDir -Force | Out-Null

    $accidentalRepoLink = Join-Path $DotfilesDir "eza\theme.yml"
    if (Test-Path -LiteralPath $accidentalRepoLink) {
        $repoItem = Get-Item -LiteralPath $accidentalRepoLink -Force
        if ($repoItem.LinkType -eq "SymbolicLink") {
            Remove-Item -LiteralPath $accidentalRepoLink -Force
            $result.Notes += "Removed accidental repository symlink: $accidentalRepoLink"
        }
    }

    Set-SymlinkSafely -Source $source -Target $target

    $result.AfterVersion = Get-CommandSemanticVersion -CommandName $binary
    $result.Status = "ok"
    $result.Notes += $installResult.Message
    $result.Notes += "Linked eza theme to $target"
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
