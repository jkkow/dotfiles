param(
    [Parameter(Mandatory = $true)][string]$DotfilesDir,
    [Parameter(Mandatory = $true)][string]$HelpersPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. $HelpersPath

$tool = "yazi"
$packageId = "sxyazi.yazi"
$binary = "yazi"

$dependencies = @(
    @{ ToolName = "ffmpeg"; PackageId = "Gyan.FFmpeg"; CommandName = "ffmpeg" },
    @{ ToolName = "7zip"; PackageId = "7zip.7zip"; CommandName = "7z" },
    @{ ToolName = "jq"; PackageId = "jqlang.jq"; CommandName = "jq" },
    @{ ToolName = "poppler"; PackageId = "oschwartz10612.Poppler"; CommandName = "pdftotext" },
    @{ ToolName = "fd"; PackageId = "sharkdp.fd"; CommandName = "fd" },
    @{ ToolName = "ripgrep"; PackageId = "BurntSushi.ripgrep.MSVC"; CommandName = "rg" },
    @{ ToolName = "fzf"; PackageId = "junegunn.fzf"; CommandName = "fzf" },
    @{ ToolName = "zoxide"; PackageId = "ajeetdsouza.zoxide"; CommandName = "zoxide" },
    @{ ToolName = "imagemagick"; PackageId = "ImageMagick.ImageMagick"; CommandName = "magick" }
)

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

    $dependencyFailures = New-Object System.Collections.Generic.List[string]
    foreach ($dependency in $dependencies) {
        $dependencyResult = Install-WingetPackageWithPolicy -PackageId $dependency.PackageId -ToolName $dependency.ToolName -CommandName $dependency.CommandName
        $result.Notes += "Dependency [$($dependency.ToolName)] $($dependencyResult.Action): $($dependencyResult.Message)"

        if (-not $dependencyResult.Success) {
            $dependencyFailures.Add("$($dependency.ToolName) ($($dependency.PackageId))")
        }
    }

    if ($dependencyFailures.Count -gt 0) {
        throw "Required Yazi dependencies failed: $($dependencyFailures -join ', ')"
    }

    $installResult = Install-WingetPackageWithPolicy -PackageId $packageId -ToolName $tool -CommandName $binary
    $result.Action = $installResult.Action
    $result.MinRequiredVersion = $installResult.MinRequiredVersion
    if (-not $installResult.Success) {
        throw $installResult.Message
    }

    $source = Join-Path $DotfilesDir "yazi"
    $target = Join-Path $HOME ".config\yazi"
    Set-SymlinkSafely -Source $source -Target $target

    $result.AfterVersion = Get-CommandSemanticVersion -CommandName $binary
    $result.Status = "ok"
    $result.Notes += $installResult.Message
    $result.Notes += "Linked yazi config directory to $target"
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
