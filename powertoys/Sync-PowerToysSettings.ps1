[CmdletBinding()]
param(
    [ValidateSet("Export", "Import")]
    [string]$Mode = "Export"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$trackedRoot = $PSScriptRoot
$liveRoot = Join-Path $env:LOCALAPPDATA "Microsoft\PowerToys"
$commandPaletteLiveSettings = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.CommandPalette_8wekyb3d8bbwe\LocalState\settings.json"
$commandPaletteTrackedSettings = Join-Path $trackedRoot "CommandPalette\settings.json"
$excludedPaths = @(
    "CommandPalette/settings.json",
    "MouseWithoutBorders/settings.json",
    "NewPlus/settings.json",
    "PowerToys Run/settings.json"
)
$commandPaletteBuiltInProviders = @(
    "AllApps",
    "Bookmarks",
    "Files",
    "PerformanceMonitor",
    "WinGet",
    "WindowWalker",
    "Windows.ClipboardHistory",
    "Windows.Registry",
    "Windows.Services",
    "WindowsTerminalProfiles"
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

function Test-CommandPaletteBuiltInProvider {
    param(
        [Parameter(Mandatory)]
        [string]$ProviderId
    )

    return $ProviderId -in $commandPaletteBuiltInProviders -or
        $ProviderId -like "com.microsoft.cmdpal.builtin.*"
}

function Export-CommandPaletteSettings {
    if (-not (Test-Path -LiteralPath $commandPaletteLiveSettings -PathType Leaf)) {
        return $false
    }

    $settings = Get-Content -LiteralPath $commandPaletteLiveSettings -Raw |
        ConvertFrom-Json -AsHashtable -ErrorAction Stop

    # Positions, images, and command bindings can reference a specific machine.
    foreach ($property in "Aliases", "CommandHotkeys", "FallbackRanks", "LastWindowPosition", "BackgroundImagePath") {
        $null = $settings.Remove($property)
    }

    if ($settings.Contains("ProviderSettings")) {
        $portableProviders = [ordered]@{}
        foreach ($provider in $settings["ProviderSettings"].GetEnumerator()) {
            if (Test-CommandPaletteBuiltInProvider -ProviderId $provider.Key) {
                $null = $provider.Value.Remove("PinnedCommandIds")
                $portableProviders[$provider.Key] = $provider.Value
            }
        }
        $settings["ProviderSettings"] = $portableProviders
    }

    if ($settings.Contains("DockSettings")) {
        foreach ($property in "BackgroundImagePath", "MonitorConfigs", "StartBands", "CenterBands", "EndBands") {
            $null = $settings["DockSettings"].Remove($property)
        }
    }

    New-Item -ItemType Directory -Path (Split-Path -Parent $commandPaletteTrackedSettings) -Force | Out-Null
    $json = $settings | ConvertTo-Json -Depth 100
    [System.IO.File]::WriteAllText(
        $commandPaletteTrackedSettings,
        (($json -replace "`r`n", "`n") + "`n"),
        [System.Text.UTF8Encoding]::new($false)
    )
    return $true
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

    $commandPaletteExported = Export-CommandPaletteSettings
    $commandPaletteMessage = if ($commandPaletteExported) { " including Command Palette" } else { "" }
    "Exported $($files.Count) portable PowerToys settings file(s)$commandPaletteMessage."
    return
}

if (Get-Process -Name "PowerToys", "CommandPalette" -ErrorAction SilentlyContinue) {
    throw "Quit PowerToys and Command Palette before importing settings."
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

$commandPaletteMessage = ""
if (Test-Path -LiteralPath $commandPaletteTrackedSettings -PathType Leaf) {
    $commandPaletteFile = Get-Item -LiteralPath $commandPaletteTrackedSettings
    Assert-JsonFile -File $commandPaletteFile

    if (Test-Path -LiteralPath (Split-Path -Parent $commandPaletteLiveSettings) -PathType Container) {
        if (Test-Path -LiteralPath $commandPaletteLiveSettings -PathType Leaf) {
            $backup = Join-Path $backupRoot "CommandPalette\settings.json"
            New-Item -ItemType Directory -Path (Split-Path -Parent $backup) -Force | Out-Null
            Copy-Item -LiteralPath $commandPaletteLiveSettings -Destination $backup
        }

        New-Item -ItemType Directory -Path (Split-Path -Parent $commandPaletteLiveSettings) -Force | Out-Null
        Copy-Item -LiteralPath $commandPaletteTrackedSettings -Destination $commandPaletteLiveSettings -Force
        $commandPaletteMessage = " including Command Palette"
    }
    else {
        $commandPaletteMessage = ". Command Palette was skipped because its local settings directory is not initialized"
    }
}

"Imported $($files.Count) portable PowerToys settings file(s)$commandPaletteMessage. Backup: $backupRoot"
