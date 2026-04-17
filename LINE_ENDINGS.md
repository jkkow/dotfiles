# Line Endings Guide

This repository uses a single line-ending policy so files behave the same on Windows, Linux, and WSL.

## Policy

- Repository text files are normalized to `LF`.
- PowerShell files (`*.ps1`, `*.psm1`, `*.psd1`) are also `LF`.
- Windows launcher scripts (`*.bat`, `*.cmd`) stay `CRLF`.
- Binary files are excluded from text normalization.

These rules are enforced by:

- `.gitattributes` (Git checkout/commit behavior)
- `.editorconfig` (editor save behavior)

## Recommended local Git settings

Set these in this repository to avoid accidental CRLF conversions:

```powershell
git config core.autocrlf false
git config core.eol lf
git config core.safecrlf warn
```

## One-time normalization after policy changes

If you still see `^M` or mixed endings, re-normalize tracked files:

```powershell
git add --renormalize .
git status
```

Then review and commit only intended changes.

## Verify current state

Use Git's EOL report:

```powershell
git ls-files --eol
git ls-files --eol "*.ps1"
```

Look for `w/mixed` entries and normalize those files first.
