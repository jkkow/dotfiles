Set-StrictMode -Version Latest

function Write-LogInfo {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-LogSuccess {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-LogWarning {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Write-LogError {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Test-IsAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function Convert-BoundParametersToArgs {
    param([Parameter(Mandatory = $true)][hashtable]$BoundParameters)

    $argsList = New-Object System.Collections.Generic.List[string]
    foreach ($key in $BoundParameters.Keys) {
        $value = $BoundParameters[$key]
        if ($null -eq $value) {
            continue
        }

        if ($value -is [System.Management.Automation.SwitchParameter]) {
            if ($value.IsPresent) {
                $argsList.Add("-$key")
            }
            continue
        }

        if ($value -is [System.Array]) {
            foreach ($item in $value) {
                $argsList.Add("-$key")
                $argsList.Add([string]$item)
            }
            continue
        }

        $argsList.Add("-$key")
        $argsList.Add([string]$value)
    }

    return $argsList
}

function Ensure-RunningAsAdministrator {
    param(
        [Parameter(Mandatory = $true)][string]$ScriptPath,
        [Parameter(Mandatory = $true)][hashtable]$BoundParameters
    )

    if (Test-IsAdministrator) {
        return
    }

    Write-LogWarning "Administrator privileges are required. Relaunching in elevated PowerShell..."

    $argumentList = New-Object System.Collections.Generic.List[string]
    $argumentList.Add("-NoProfile")
    $argumentList.Add("-ExecutionPolicy")
    $argumentList.Add("Bypass")
    $argumentList.Add("-File")
    $argumentList.Add($ScriptPath)

    $forwarded = Convert-BoundParametersToArgs -BoundParameters $BoundParameters
    foreach ($arg in $forwarded) {
        $argumentList.Add($arg)
    }

    if (-not $BoundParameters.ContainsKey("PauseAtEnd")) {
        $argumentList.Add("-PauseAtEnd")
    }

    $process = Start-Process -FilePath "pwsh" -ArgumentList $argumentList -Verb RunAs -Wait -PassThru
    exit $process.ExitCode
}

function Ensure-Directory {
    param([Parameter(Mandatory = $true)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Set-SymlinkSafely {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Target
    )

    if (-not (Test-Path -LiteralPath $Source)) {
        throw "Source path not found: $Source"
    }

    $normalizedSource = [System.IO.Path]::GetFullPath($Source).TrimEnd('\\')
    $normalizedTarget = [System.IO.Path]::GetFullPath($Target).TrimEnd('\\')
    if ($normalizedSource -eq $normalizedTarget) {
        return
    }

    $targetParent = Split-Path -Path $Target -Parent
    if ([string]::IsNullOrWhiteSpace($targetParent)) {
        throw "Could not resolve parent directory for target: $Target"
    }
    Ensure-Directory -Path $targetParent

    if (Test-Path -LiteralPath $Target) {
        try {
            $resolvedSource = (Resolve-Path -LiteralPath $Source).Path
            $resolvedTarget = (Resolve-Path -LiteralPath $Target).Path
            if ($resolvedSource -eq $resolvedTarget) {
                return
            }
        }
        catch {
        }

        $targetItem = Get-Item -LiteralPath $Target -Force
        if ($targetItem.LinkType -eq "SymbolicLink") {
            $existingTarget = $targetItem.Target
            if ($existingTarget -eq $Source) {
                return
            }
        }

        $timestamp = Get-Date -Format "yyyyMMddHHmmss"
        $backupPath = "$Target.bak.$timestamp"
        Move-Item -LiteralPath $Target -Destination $backupPath -Force
        Write-LogWarning "Backed up existing path to: $backupPath"
    }

    New-Item -ItemType SymbolicLink -Path $Target -Target $Source -Force | Out-Null
}

function Get-CommandSemanticVersion {
    param([Parameter(Mandatory = $true)][string]$CommandName)

    if (-not (Get-Command $CommandName -ErrorAction SilentlyContinue)) {
        return "not-installed"
    }

    $output = & $CommandName --version 2>$null
    if (-not $output) {
        return "unknown"
    }

    $text = ($output | Out-String)
    $match = [regex]::Match($text, "(\d+)\.(\d+)\.(\d+)")
    if ($match.Success) {
        return $match.Value
    }

    $shortMatch = [regex]::Match($text, "(\d+)\.(\d+)")
    if ($shortMatch.Success) {
        return "$($shortMatch.Groups[1].Value).$($shortMatch.Groups[2].Value).0"
    }

    return "unknown"
}

function Get-MinRequiredVersionPath {
    $installationDir = Split-Path -Parent $PSScriptRoot
    return (Join-Path $installationDir "min-required-versions.txt")
}

function Get-MinRequiredVersion {
    param([Parameter(Mandatory = $true)][string]$ToolName)

    $versionFile = Get-MinRequiredVersionPath
    if (-not (Test-Path -LiteralPath $versionFile)) {
        return $null
    }

    $lines = Get-Content -LiteralPath $versionFile
    foreach ($line in $lines) {
        $trimmed = $line.Trim()
        if ([string]::IsNullOrWhiteSpace($trimmed) -or $trimmed.StartsWith("#")) {
            continue
        }

        if ($trimmed -notmatch "=") {
            continue
        }

        $parts = $trimmed.Split("=", 2)
        $key = $parts[0].Trim()
        $value = $parts[1].Trim()
        if ($key -eq $ToolName) {
            return $value
        }
    }

    return $null
}

function Test-VersionAtLeast {
    param(
        [Parameter(Mandatory = $true)][string]$InstalledVersion,
        [Parameter(Mandatory = $true)][string]$RequiredVersion
    )

    if ($InstalledVersion -in @("not-installed", "unknown") -or [string]::IsNullOrWhiteSpace($InstalledVersion)) {
        return $false
    }

    if ([string]::IsNullOrWhiteSpace($RequiredVersion)) {
        return $true
    }

    if (($InstalledVersion -notmatch "^\d+\.\d+\.\d+$") -or ($RequiredVersion -notmatch "^\d+\.\d+\.\d+$")) {
        return $false
    }

    $iParts = $InstalledVersion.Split(".")
    $rParts = $RequiredVersion.Split(".")
    for ($i = 0; $i -lt 3; $i++) {
        $iNum = [int]$iParts[$i]
        $rNum = [int]$rParts[$i]
        if ($iNum -gt $rNum) {
            return $true
        }
        if ($iNum -lt $rNum) {
            return $false
        }
    }

    return $true
}

function Invoke-WingetCommand {
    param([Parameter(Mandatory = $true)][string[]]$Arguments)

    $output = & winget @Arguments 2>&1
    $exitCode = $LASTEXITCODE

    return [pscustomobject]@{
        ExitCode = $exitCode
        Output   = ($output | Out-String).Trim()
    }
}

function Test-WingetPackageInstalled {
    param([Parameter(Mandatory = $true)][string]$PackageId)

    $result = Invoke-WingetCommand -Arguments @("list", "--id", $PackageId, "--exact", "--accept-source-agreements")
    if ($result.ExitCode -ne 0) {
        return $false
    }

    return $result.Output -match [regex]::Escape($PackageId)
}

function Install-WingetPackageWithPolicy {
    param(
        [Parameter(Mandatory = $true)][string]$PackageId,
        [Parameter(Mandatory = $true)][string]$ToolName,
        [Parameter(Mandatory = $true)][string]$CommandName
    )

    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        return [pscustomobject]@{
            Success            = $false
            Action             = "failed"
            Message            = "winget is not available on this system."
            MinRequiredVersion = (Get-MinRequiredVersion -ToolName $ToolName)
        }
    }

    $showResult = Invoke-WingetCommand -Arguments @("show", "--id", $PackageId, "--exact", "--accept-source-agreements")
    if ($showResult.ExitCode -ne 0) {
        return [pscustomobject]@{
            Success            = $false
            Action             = "failed"
            Message            = "Package ID not found in winget sources: $PackageId"
            MinRequiredVersion = (Get-MinRequiredVersion -ToolName $ToolName)
        }
    }

    $requiredVersion = Get-MinRequiredVersion -ToolName $ToolName
    $beforeVersion = Get-CommandSemanticVersion -CommandName $CommandName
    $isInstalled = Test-WingetPackageInstalled -PackageId $PackageId

    if ($isInstalled) {
        if ([string]::IsNullOrWhiteSpace($requiredVersion)) {
            return [pscustomobject]@{
                Success            = $true
                Action             = "skipped"
                Message            = "Package is already installed (no minimum version policy configured)."
                MinRequiredVersion = "n/a"
            }
        }

        if (Test-VersionAtLeast -InstalledVersion $beforeVersion -RequiredVersion $requiredVersion) {
            return [pscustomobject]@{
                Success            = $true
                Action             = "skipped"
                Message            = "Installed version $beforeVersion meets minimum $requiredVersion."
                MinRequiredVersion = $requiredVersion
            }
        }
    }

    $installResult = Invoke-WingetCommand -Arguments @(
        "install",
        "--id", $PackageId,
        "--exact",
        "--scope", "machine",
        "--accept-source-agreements",
        "--accept-package-agreements",
        "--silent",
        "--disable-interactivity"
    )

    if ($installResult.ExitCode -ne 0) {
        return [pscustomobject]@{
            Success            = $false
            Action             = "failed"
            Message            = $installResult.Output
            MinRequiredVersion = $(if ([string]::IsNullOrWhiteSpace($requiredVersion)) { "n/a" } else { $requiredVersion })
        }
    }

    $afterVersion = Get-CommandSemanticVersion -CommandName $CommandName
    if ($requiredVersion -and -not (Test-VersionAtLeast -InstalledVersion $afterVersion -RequiredVersion $requiredVersion)) {
        return [pscustomobject]@{
            Success            = $false
            Action             = "failed"
            Message            = "Install completed but version check failed: installed $afterVersion, required $requiredVersion."
            MinRequiredVersion = $requiredVersion
        }
    }

    $action = if ($isInstalled) { "updated" } else { "installed" }
    return [pscustomobject]@{
        Success            = $true
        Action             = $action
        Message            = $installResult.Output
        MinRequiredVersion = $(if ([string]::IsNullOrWhiteSpace($requiredVersion)) { "n/a" } else { $requiredVersion })
    }
}
