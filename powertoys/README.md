# PowerToys

This directory is the portable, tracked PowerToys configuration snapshot. It
is an explicit export, not a link to live application state.

## Included

- `manifest.json`, which records source versions and the exact files managed by
  an import.
- Portable global and module `settings.json` files, including configured
  shortcuts.
- `CommandPalette/settings.json`, with its activation shortcut, core appearance,
  behavior, built-in provider preferences, and supported static aliases.
- Existing built-in Command Palette `*.settings.json` companion files. These
  files are created only after a provider setting has changed from its default.

## Excluded

- `MouseWithoutBorders/settings.json`, which contains a pairing security key,
  machine identity, and connection state.
- `NewPlus/settings.json` and `PowerToys Run/settings.json`, which contain
  machine-local paths.
- Logs, telemetry, update state, window placement, and version markers.
- PowerDisplay monitor identities, mappings, and synchronization exclusions.
- Command Palette command-specific hotkeys, pins, third-party provider settings,
  display state, dock command bands, image paths, history, and caches.
- Dynamic, app-specific, third-party, profile, and layout Command Palette
  aliases. Static `com.microsoft.powertoys.*` aliases and known static
  Command Palette aliases are retained. The retired
  `com.microsoft.cmdpal.shell` alias is migrated to `com.microsoft.cmdpal.run`.

Advanced Paste AI providers are removed from exports to prevent credentials from
being committed.

## Install

On Windows, install PowerToys with Winget:

```powershell
winget install --id Microsoft.PowerToys --exact --scope machine
```

Command Palette is a separate Windows package. Install it from Microsoft Store,
then open it once before importing settings.

## Export Current Settings

After changing settings in the PowerToys or Command Palette UI, run:

```powershell
.\powertoys\Sync-PowerToysSettings.ps1 -Mode Export
git diff -- powertoys
```

Review and commit intentional changes. The manifest controls future imports, so
older tracked files are never imported unless the current export lists them.

## Import on Another Computer

Install PowerToys. Install and open Command Palette once so its AppX `LocalState`
directory is initialized, then quit both applications completely before running:

```powershell
.\powertoys\Sync-PowerToysSettings.ps1 -Mode Import -WhatIf
.\powertoys\Sync-PowerToysSettings.ps1 -Mode Import
```

`-WhatIf` reports replacements and skipped settings without changing anything.
The import validates the manifest and tracked JSON, warns when source and target
versions differ, imports only manifest-listed files, and backs up every replaced
file beside the live PowerToys configuration. It skips unavailable modules and
an uninitialized Command Palette. Start both applications after import.
