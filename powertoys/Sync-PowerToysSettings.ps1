[CmdletBinding()]
param(
    [ValidateSet("Export", "Import")]
    [string]$Mode = "Export"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$trackedRoot = $PSScriptRoot
$liveRoot = Join-Path $env:LOCALAPPDATA "Microsoft\PowerToys"
$excludedPaths = @(
    "MouseWithoutBorders/settings.json",
    "NewPlus/settings.json",
    "PowerToys Run/settings.json"
)

function Get-RelativePath {
    param(
        [Parameter(Mandatory)]
        [string]$Root,

        [Parameter(Mandatory)]
        [string]$Path
    )

    return ($Path.Substring($Root.Length).TrimStart("\") -replace "\\", "/")
}

function Get-PortableSettingsFiles {
    param(
        [Parameter(Mandatory)]
        [string]$Root
    )

    return Get-ChildItem -LiteralPath $Root -Recurse -File -Filter "settings.json" |
        Where-Object {
            (Get-RelativePath -Root $Root -Path $_.FullName) -notin $excludedPaths
        }
}

function Assert-JsonFile {
    param(
        [Parameter(Mandatory)]
        [System.IO.FileInfo]$File
    )

    try {
        Get-Content -LiteralPath $File.FullName -Raw | ConvertFrom-Json -ErrorAction Stop | Out-Null
    }
    catch {
        throw "Invalid JSON in $($File.FullName): $($_.Exception.Message)"
    }
}

if ($Mode -eq "Export") {
    if (-not (Test-Path -LiteralPath $liveRoot -PathType Container)) {
        throw "PowerToys configuration directory was not found: $liveRoot"
    }

    $files = @(Get-PortableSettingsFiles -Root $liveRoot)
    foreach ($file in $files) {
        Assert-JsonFile -File $file
        $relativePath = Get-RelativePath -Root $liveRoot -Path $file.FullName
        $destination = Join-Path $trackedRoot ($relativePath -replace "/", "\")
        $destinationDirectory = Split-Path -Parent $destination
        New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
        Copy-Item -LiteralPath $file.FullName -Destination $destination -Force
    }

    "Exported $($files.Count) portable PowerToys settings file(s)."
    return
}

if (Get-Process -Name "PowerToys" -ErrorAction SilentlyContinue) {
    throw "Quit PowerToys before importing settings."
}

if (-not (Test-Path -LiteralPath $liveRoot -PathType Container)) {
    throw "PowerToys configuration directory was not found: $liveRoot"
}

$files = @(Get-PortableSettingsFiles -Root $trackedRoot)
if ($files.Count -eq 0) {
    throw "No portable PowerToys settings were found in $trackedRoot"
}

$backupRoot = Join-Path (Split-Path -Parent $liveRoot) ("PowerToys.portable-backup-{0}" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
foreach ($file in $files) {
    Assert-JsonFile -File $file
    $relativePath = Get-RelativePath -Root $trackedRoot -Path $file.FullName
    $destination = Join-Path $liveRoot ($relativePath -replace "/", "\")

    if (Test-Path -LiteralPath $destination -PathType Leaf) {
        $backup = Join-Path $backupRoot ($relativePath -replace "/", "\")
        New-Item -ItemType Directory -Path (Split-Path -Parent $backup) -Force | Out-Null
        Copy-Item -LiteralPath $destination -Destination $backup
    }

    New-Item -ItemType Directory -Path (Split-Path -Parent $destination) -Force | Out-Null
    Copy-Item -LiteralPath $file.FullName -Destination $destination -Force
}

"Imported $($files.Count) portable PowerToys settings file(s). Backup: $backupRoot"
