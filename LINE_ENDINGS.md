# Line Endings Guide

This repository uses a consistent line-ending policy so files behave the same on Windows, Linux, and WSL and so `^M` does not keep returning.

## What `^M` means

`^M` is a visible carriage return character (`\r`). It appears when a file uses `CRLF` line endings (`\r\n`) and is viewed in a tool that expects `LF` (`\n`).

## Policy

- Repository text files are normalized to `LF`.
- PowerShell files (`*.ps1`, `*.psm1`, `*.psd1`) are also `LF`.
- Windows launcher scripts (`*.bat`, `*.cmd`) stay `CRLF`.
- Binary files are excluded from text normalization.

These rules are enforced by:

- `.gitattributes` (Git checkout and commit behavior)
- `.editorconfig` (editor save behavior)

## `.gitignore` is not for line endings

`.gitignore` only controls what Git tracks. It does not control line endings.

Use `.gitattributes` and Git config for line-ending management.

## Recommended Git settings

### 1) Global baseline (recommended)

Copy and run:

```powershell
git config --global core.autocrlf false
git config --global core.safecrlf warn
```

Optional (use this if you want LF-first behavior globally):

```powershell
git config --global core.eol lf
```

### 2) Repository-local settings (this repo)

Copy and run:

```powershell
git config core.autocrlf false
git config core.eol lf
git config core.safecrlf warn
```

### 3) Verify effective values

Copy and run:

```powershell
git config --show-origin --get core.autocrlf
git config --show-origin --get core.eol
git config --show-origin --get core.safecrlf
```

## Diagnose current state

Copy and run:

```powershell
git ls-files --eol
```

How to read output:

- `i/...` is the index (what Git stores)
- `w/...` is the working tree (your file on disk)
- `attr/...` is the rule from `.gitattributes`

If you see `i/lf w/crlf ... eol=lf`, the repo is LF but the working copy currently has CRLF.

## Targeted fix (safe and minimal)

This converts only tracked files that are currently `w/crlf` but should be `eol=lf`.

Copy and run:

```powershell
$targets = git ls-files --eol |
  Where-Object { $_ -match 'w/crlf' -and $_ -match 'eol=lf' } |
  ForEach-Object { ($_ -split "`t", 2)[1] }

$dirty = git diff --name-only
$safeTargets = $targets | Where-Object { $dirty -notcontains $_ }
$skipped = $targets | Where-Object { $dirty -contains $_ }

"Targets: $($targets.Count)"
"Will fix: $($safeTargets.Count)"
"Skipped (dirty): $($skipped.Count)"

foreach ($path in $safeTargets) {
  $reader = [System.IO.StreamReader]::new($path, $true)
  try {
    $text = $reader.ReadToEnd()
    $encoding = $reader.CurrentEncoding
  }
  finally {
    $reader.Close()
  }

  if ($text.Contains("`r`n")) {
    $fixed = $text -replace "`r`n", "`n"
    [System.IO.File]::WriteAllText($path, $fixed, $encoding)
  }
}
```

Verify the result:

```powershell
git ls-files --eol | Select-String 'w/crlf.*eol=lf'
```

If this prints nothing, mismatches are fixed.

## One-time full renormalization (alternative)

Use this when policy changed and you intentionally want a broader normalization pass.

Copy and run:

```powershell
git add --renormalize .
git status
```

Then review and commit only intended changes.

## Quick checks

Copy and run:

```powershell
git ls-files --eol
git ls-files --eol "*.ps1"
git status --short
```
