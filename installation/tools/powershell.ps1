param(
    [Parameter(Mandatory = $true)][string]$DotfilesDir,
    [Parameter(Mandatory = $true)][string]$HelpersPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. $HelpersPath

function Get-RunningPowerShellVersion {
    if ($null -eq $PSVersionTable -or $null -eq $PSVersionTable.PSVersion) {
        return $null
    }

    return $PSVersionTable.PSVersion.ToString()
}

$tool = "powershell"
$packageId = "Microsoft.PowerShell"
$binary = "pwsh"

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
    $requiredVersion = Get-MinRequiredVersion -ToolName $tool
    $runningVersion = Get-RunningPowerShellVersion
    $result.BeforeVersion = if ([string]::IsNullOrWhiteSpace($runningVersion)) {
        Get-CommandSemanticVersion -CommandName $binary
    }
    else {
        $runningVersion
    }
    $result.VersionSource = if ([string]::IsNullOrWhiteSpace($runningVersion)) { "command" } else { "running-shell" }

    if ($requiredVersion -and (Test-VersionAtLeastForTool -InstalledVersion $result.BeforeVersion -RequiredVersion $requiredVersion -ToolName $tool)) {
        $result.Action = "skipped"
        $result.MinRequiredVersion = $requiredVersion
        $result.Notes += "Installed version $($result.BeforeVersion) meets minimum $requiredVersion."
    }
    else {
        $installResult = Install-WingetPackageWithPolicy -PackageId $packageId -ToolName $tool -CommandName $binary
        $result.Action = $installResult.Action
        $result.MinRequiredVersion = $installResult.MinRequiredVersion
        $result.BeforeVersion = $installResult.DetectedBeforeVersion
        $result.VersionSource = $installResult.VersionSource

        if (-not $installResult.Success) {
            Write-LogWarning "Machine-scope PowerShell install failed; retrying with default scope."
            $fallbackInstall = Invoke-WingetCommand -Arguments @(
                "install",
                "--id", $packageId,
                "--exact",
                "--accept-source-agreements",
                "--accept-package-agreements",
                "--silent",
                "--disable-interactivity"
            )

            if ($fallbackInstall.ExitCode -ne 0) {
                throw "Machine-scope install failed. Fallback install also failed. Primary error: $($installResult.Message) Fallback error: $($fallbackInstall.Output)"
            }

            $result.Action = if ($result.BeforeVersion -in @("not-installed", "unknown")) { "installed" } else { "updated" }
            $result.MinRequiredVersion = $(if ([string]::IsNullOrWhiteSpace($requiredVersion)) { "n/a" } else { $requiredVersion })
            $result.Notes += "Machine-scope install failed; fallback to default scope succeeded."
            $result.Notes += $fallbackInstall.Output
        }
        else {
            $result.Notes += $installResult.Message
        }
    }

    $source = Join-Path $DotfilesDir "powershell"
    $target = Join-Path $HOME ".config\powershell"
    Set-SymlinkSafely -Source $source -Target $target

    $runningAfterVersion = Get-RunningPowerShellVersion
    $commandAfterVersion = Get-CommandSemanticVersion -CommandName $binary
    $result.AfterVersion = if (-not [string]::IsNullOrWhiteSpace($commandAfterVersion) -and $commandAfterVersion -ne "unknown") {
        $commandAfterVersion
    }
    else {
        $runningAfterVersion
    }
    $result.VersionSource = if (-not [string]::IsNullOrWhiteSpace($commandAfterVersion) -and $commandAfterVersion -ne "unknown") { "command" } else { "running-shell" }

    if ($requiredVersion -and -not (Test-VersionAtLeastForTool -InstalledVersion $result.AfterVersion -RequiredVersion $requiredVersion -ToolName $tool)) {
        throw "PowerShell version check failed after install: installed $($result.AfterVersion), required $requiredVersion."
    }

    $result.Status = "ok"
    $result.Notes += "Linked powershell config directory to $target"
}
catch {
    $result.Action = "failed"
    $result.Status = "failed"
    $result.Notes += $_.Exception.Message
}
finally {
    if ($result.AfterVersion -in @("not-installed", "unknown", $null, "")) {
        $commandVersion = Get-CommandSemanticVersion -CommandName $binary
        $result.AfterVersion = if (-not [string]::IsNullOrWhiteSpace($commandVersion) -and $commandVersion -ne "unknown") {
            $commandVersion
        }
        else {
            Get-RunningPowerShellVersion
        }

        if (-not [string]::IsNullOrWhiteSpace($commandVersion) -and $commandVersion -ne "unknown") {
            $result.VersionSource = "command"
        }
        else {
            $result.VersionSource = "running-shell"
        }
    }

    if ([string]::IsNullOrWhiteSpace($result.VersionSource)) {
        $result.VersionSource = "unknown"
    }
}

[pscustomobject]$result
