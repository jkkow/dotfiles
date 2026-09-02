# PowerToys

This directory is the portable, tracked PowerToys configuration snapshot. It
mirrors approved `settings.json` files from
`%LOCALAPPDATA%\Microsoft\PowerToys`; it is not linked to that live directory.

## Included

- The global `settings.json`, including enabled modules and global shortcuts.
- Module `settings.json` files, including each module's configured shortcuts.

## Excluded

- `MouseWithoutBorders/settings.json`, which contains a pairing security key,
  machine identity, and connection state.
- `NewPlus/settings.json` and `PowerToys Run/settings.json`, which contain
  machine-local paths.
- Logs, telemetry, update state, window placement, and version markers.

Review Advanced Paste settings before exporting if AI providers are configured;
provider credentials must not be committed.

## Install

On Windows, install PowerToys with Winget:

```powershell
winget install --id Microsoft.PowerToys --exact --scope machine
```

## Export Current Settings

After changing settings in the PowerToys UI, run:

```powershell
.\powertoys\Sync-PowerToysSettings.ps1 -Mode Export
git diff -- powertoys
```

Review and commit intentional changes. Exporting does not remove an older
tracked module file, so remove obsolete files deliberately after review.

## Import on Another Computer

Install and open PowerToys once, then quit it completely from the notification
area before running:

```powershell
.\powertoys\Sync-PowerToysSettings.ps1 -Mode Import
```

The import validates tracked JSON and backs up every live file it replaces to a
timestamped directory beside the live PowerToys configuration. Start PowerToys
after the command completes.
