[CmdletBinding(SupportsShouldProcess)]
param(
    [ValidateSet("Export", "Import")]
    [string]$Mode = "Export"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$trackedRoot = $PSScriptRoot
$liveRoot = Join-Path $env:LOCALAPPDATA "Microsoft\PowerToys"
$manifestPath = Join-Path $trackedRoot "manifest.json"
$excludedPaths = @(
    "CommandPalette/settings.json",
    "MouseWithoutBorders/settings.json",
    "NewPlus/settings.json",
    "PowerToys Run/settings.json"
)
$commandPaletteExtensionFiles = @(
    "apps.settings.json",
    "calculator.settings.json",
    "clipboardHistory.settings.json",
    "com.microsoft.cmdpal.builtin.remotedesktop.settings.json",
    "performanceMonitor.settings.json",
    "registry.settings.json",
    "shell.settings.json",
    "system.settings.json",
    "timeDate.settings.json",
    "websearch.settings.json",
    "windowWalker.settings.json",
    "wt.settings.json"
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
$commandPaletteStaticCommandIds = @(
    "com.microsoft.cmdpal.builtin.remotedesktop",
    "com.microsoft.cmdpal.calculator",
    "com.microsoft.cmdpal.clipboardHistory",
    "com.microsoft.cmdpal.run",
    "com.microsoft.cmdpal.timedate",
    "com.microsoft.cmdpal.websearch",
    "com.microsoft.cmdpal.windowwalker",
    "com.microsoft.cmdpal.windowsSettings",
    "com.microsoft.indexer.fileSearch"
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

function Get-JsonData {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    try {
        return Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json -AsHashtable -ErrorAction Stop
    }
    catch {
        throw "Invalid JSON in ${Path}: $($_.Exception.Message)"
    }
}

function Write-JsonData {
    param(
        [Parameter(Mandatory)]
        [object]$Data,

        [Parameter(Mandatory)]
        [string]$Path
    )

    $json = $Data | ConvertTo-Json -Depth 100
    New-Item -ItemType Directory -Path (Split-Path -Parent $Path) -Force | Out-Null
    [System.IO.File]::WriteAllText(
        $Path,
        (($json -replace "`r`n", "`n") + "`n"),
        [System.Text.UTF8Encoding]::new($false)
    )
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

function Get-CommandPaletteState {
    $package = Get-AppxPackage -Name "Microsoft.CommandPalette" -ErrorAction SilentlyContinue |
        Sort-Object Version -Descending |
        Select-Object -First 1
    if (-not $package) {
        return $null
    }

    $localState = Join-Path $env:LOCALAPPDATA "Packages\$($package.PackageFamilyName)\LocalState"
    return [ordered]@{
        Package = $package
        LocalState = $localState
        SettingsPath = Join-Path $localState "settings.json"
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

function Test-PortableCommandPaletteAlias {
    param(
        [Parameter(Mandatory)]
        [string]$CommandId
    )

    return $CommandId -like "com.microsoft.powertoys.*" -or
        $CommandId -in $commandPaletteStaticCommandIds
}

function Remove-NonPortableProperties {
    param(
        [Parameter(Mandatory)]
        [AllowNull()]
        [object]$Value
    )

    if ($Value -is [System.Collections.IDictionary]) {
        foreach ($key in @($Value.Keys)) {
            if ($key -match "(?i)(api.?key|credential|device|history|monitor|password|path|pinned|secret|token)") {
                $null = $Value.Remove($key)
            }
            else {
                Remove-NonPortableProperties -Value $Value[$key]
            }
        }
    }
    elseif ($Value -is [System.Collections.IEnumerable] -and $Value -isnot [string]) {
        foreach ($item in $Value) {
            Remove-NonPortableProperties -Value $item
        }
    }
}

function ConvertTo-PortablePowerToysSettings {
    param(
        [Parameter(Mandatory)]
        [string]$RelativePath,

        [Parameter(Mandatory)]
        [string]$SourcePath
    )

    $settings = Get-JsonData -Path $SourcePath
    if ($RelativePath -eq "settings.json") {
        foreach ($property in "is_admin", "is_elevated", "powertoys_version") {
            $null = $settings.Remove($property)
        }
    }
    elseif ($RelativePath -eq "AdvancedPaste/settings.json") {
        $properties = $settings["properties"]
        if ($properties.Contains("paste-ai-configuration")) {
            $properties["paste-ai-configuration"] = [ordered]@{
                "active-provider-id" = ""
                "providers" = @()
            }
            if ($properties.Contains("IsAIEnabled")) {
                $properties["IsAIEnabled"]["value"] = $false
            }
        }
    }
    elseif ($RelativePath -eq "PowerDisplay/settings.json") {
        foreach ($property in "monitors", "excluded_from_sync_monitor_ids", "custom_vcp_mappings") {
            $null = $settings["properties"].Remove($property)
        }
    }

    return $settings
}

function Export-CommandPaletteSettings {
    param(
        [Parameter(Mandatory)]
        [System.Collections.IDictionary]$State,

        [Parameter(Mandatory)]
        [System.Collections.ArrayList]$ManagedFiles
    )

    if (-not (Test-Path -LiteralPath $State["SettingsPath"] -PathType Leaf)) {
        return
    }

    $settings = Get-JsonData -Path $State["SettingsPath"]
    foreach ($property in "CommandHotkeys", "FallbackRanks", "LastWindowPosition", "BackgroundImagePath", "PinnedCommands", "GalleryFeedUrl") {
        $null = $settings.Remove($property)
    }

    $portableAliases = [ordered]@{}
    if ($settings.Contains("Aliases")) {
        foreach ($entry in $settings["Aliases"].GetEnumerator()) {
            $commandId = [string]$entry.Value["CommandId"]
            if ($commandId -eq "com.microsoft.cmdpal.shell") {
                $commandId = "com.microsoft.cmdpal.run"
                $entry.Value["CommandId"] = $commandId
            }

            if (Test-PortableCommandPaletteAlias -CommandId $commandId) {
                $portableAliases[$entry.Key] = $entry.Value
            }
            else {
                Write-Warning "Skipped non-portable Command Palette alias: $($entry.Value["Alias"])"
            }
        }
    }
    $settings["Aliases"] = $portableAliases

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

    $trackedPath = Join-Path $trackedRoot "CommandPalette\settings.json"
    Write-JsonData -Data $settings -Path $trackedPath
    [void]$ManagedFiles.Add([ordered]@{ path = "CommandPalette/settings.json"; kind = "CommandPaletteHost" })

    foreach ($file in Get-ChildItem -LiteralPath $State["LocalState"] -File -Filter "*.settings.json" -ErrorAction SilentlyContinue) {
        if ($file.Name -notin $commandPaletteExtensionFiles) {
            continue
        }

        $extensionSettings = Get-JsonData -Path $file.FullName
        Remove-NonPortableProperties -Value $extensionSettings
        $relativePath = "CommandPalette/extensions/$($file.Name)"
        Write-JsonData -Data $extensionSettings -Path (Join-Path $trackedRoot ($relativePath -replace "/", "\"))
        [void]$ManagedFiles.Add([ordered]@{ path = $relativePath; kind = "CommandPaletteExtension" })
    }
}

function Get-TargetPowerToysVersion {
    $settingsPath = Join-Path $liveRoot "settings.json"
    if (-not (Test-Path -LiteralPath $settingsPath -PathType Leaf)) {
        return $null
    }

    return (Get-JsonData -Path $settingsPath)["powertoys_version"]
}

function Test-ManifestPath {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    if ([System.IO.Path]::IsPathRooted($Path) -or $Path -match "(^|[\\/])\.\.([\\/]|$)") {
        throw "Invalid manifest path: $Path"
    }
}

function Backup-AndCopyFile {
    param(
        [Parameter(Mandatory)]
        [string]$Source,

        [Parameter(Mandatory)]
        [string]$Destination,

        [Parameter(Mandatory)]
        [string]$Backup
    )

    if ($PSCmdlet.ShouldProcess($Destination, "Import PowerToys setting")) {
        if (Test-Path -LiteralPath $Destination -PathType Leaf) {
            New-Item -ItemType Directory -Path (Split-Path -Parent $Backup) -Force | Out-Null
            Copy-Item -LiteralPath $Destination -Destination $Backup
        }

        New-Item -ItemType Directory -Path (Split-Path -Parent $Destination) -Force | Out-Null
        Copy-Item -LiteralPath $Source -Destination $Destination -Force
        return $true
    }

    return $false
}

if ($Mode -eq "Export") {
    if (-not (Test-Path -LiteralPath $liveRoot -PathType Container)) {
        throw "PowerToys configuration directory was not found: $liveRoot"
    }

    $managedFiles = [System.Collections.ArrayList]::new()
    foreach ($file in Get-PortableSettingsFiles -Root $liveRoot) {
        $relativePath = Get-RelativePath -Root $liveRoot -Path $file.FullName
        $settings = ConvertTo-PortablePowerToysSettings -RelativePath $relativePath -SourcePath $file.FullName
        Write-JsonData -Data $settings -Path (Join-Path $trackedRoot ($relativePath -replace "/", "\"))
        [void]$managedFiles.Add([ordered]@{ path = $relativePath; kind = "PowerToys" })
    }

    $commandPaletteState = Get-CommandPaletteState
    if ($commandPaletteState) {
        Export-CommandPaletteSettings -State $commandPaletteState -ManagedFiles $managedFiles
    }

    $manifest = [ordered]@{
        schemaVersion = 1
        source = [ordered]@{
            powerToysVersion = Get-TargetPowerToysVersion
            commandPaletteVersion = if ($commandPaletteState) { $commandPaletteState["Package"].Version.ToString() } else { $null }
        }
        files = @($managedFiles | Sort-Object path)
    }
    Write-JsonData -Data $manifest -Path $manifestPath
    "Exported $($managedFiles.Count) managed PowerToys settings file(s)."
    return
}

if (-not $WhatIfPreference -and (Get-Process -Name "PowerToys", "CommandPalette" -ErrorAction SilentlyContinue)) {
    throw "Quit PowerToys and Command Palette before importing settings."
}

if (-not (Test-Path -LiteralPath $liveRoot -PathType Container)) {
    throw "PowerToys configuration directory was not found: $liveRoot"
}

if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) {
    throw "Managed PowerToys manifest was not found: $manifestPath"
}

$manifest = Get-JsonData -Path $manifestPath
if ($manifest["schemaVersion"] -ne 1) {
    throw "Unsupported PowerToys manifest schema version: $($manifest["schemaVersion"])"
}

$targetPowerToysVersion = Get-TargetPowerToysVersion
if ($manifest["source"]["powerToysVersion"] -ne $targetPowerToysVersion) {
    Write-Warning "PowerToys version differs. Source: $($manifest["source"]["powerToysVersion"]); target: $targetPowerToysVersion"
}

$commandPaletteState = Get-CommandPaletteState
$targetCommandPaletteVersion = if ($commandPaletteState) { $commandPaletteState["Package"].Version.ToString() } else { $null }
if ($manifest["source"]["commandPaletteVersion"] -ne $targetCommandPaletteVersion) {
    Write-Warning "Command Palette version differs. Source: $($manifest["source"]["commandPaletteVersion"]); target: $targetCommandPaletteVersion"
}

$targetSettings = Get-JsonData -Path (Join-Path $liveRoot "settings.json")
$backupRoot = Join-Path (Split-Path -Parent $liveRoot) ("PowerToys.portable-backup-{0}" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
$imported = 0
$planned = 0
$skipped = 0
foreach ($entry in $manifest["files"]) {
    $relativePath = [string]$entry["path"]
    Test-ManifestPath -Path $relativePath
    $source = Join-Path $trackedRoot ($relativePath -replace "/", "\")
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
        Write-Warning "Tracked setting is missing and was skipped: $relativePath"
        $skipped++
        continue
    }
    [void](Get-JsonData -Path $source)

    switch ($entry["kind"]) {
        "PowerToys" {
            if ($relativePath -ne "settings.json") {
                $moduleName = ($relativePath -split "/", 2)[0]
                if (-not $targetSettings["enabled"].Contains($moduleName)) {
                    Write-Warning "Target PowerToys does not support $moduleName; skipped $relativePath"
                    $skipped++
                    continue
                }
            }

            $destination = Join-Path $liveRoot ($relativePath -replace "/", "\")
            $backup = Join-Path $backupRoot ("PowerToys\" + ($relativePath -replace "/", "\"))
        }
        "CommandPaletteHost" {
            if (-not $commandPaletteState -or -not (Test-Path -LiteralPath $commandPaletteState["LocalState"] -PathType Container)) {
                Write-Warning "Command Palette is not initialized; skipped $relativePath"
                $skipped++
                continue
            }

            $destination = $commandPaletteState["SettingsPath"]
            $backup = Join-Path $backupRoot "CommandPalette\settings.json"
        }
        "CommandPaletteExtension" {
            if (-not $commandPaletteState -or -not (Test-Path -LiteralPath $commandPaletteState["LocalState"] -PathType Container)) {
                Write-Warning "Command Palette is not initialized; skipped $relativePath"
                $skipped++
                continue
            }

            $destination = Join-Path $commandPaletteState["LocalState"] (Split-Path -Leaf $relativePath)
            $backup = Join-Path $backupRoot ("CommandPalette\" + (Split-Path -Leaf $relativePath))
        }
        default {
            throw "Unsupported manifest setting kind: $($entry["kind"])"
        }
    }

    if (Backup-AndCopyFile -Source $source -Destination $destination -Backup $backup) {
        $imported++
    }
    else {
        $planned++
    }
}

if ($WhatIfPreference) {
    "Would import $planned managed setting(s); skipped $skipped. Backup: $backupRoot"
}
else {
    "Imported $imported managed setting(s); skipped $skipped. Backup: $backupRoot"
}
