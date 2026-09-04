# Dotfiles Agent Guide

## Scope

- This is a cross-platform dotfiles repository, not an application build/test
  repository. It is cloned directly to `$HOME/.config`; there is no installer.
- `powershell/initialize.ps1` is the PowerShell profile entrypoint and
  dot-sources the alias and module scripts. `wezterm/wezterm.lua` is the
  WezTerm entrypoint.
- Application-specific setup belongs in its directory README. Do not add
  package-installation, linking, or startup automation unless explicitly asked.

## Safety

- Before modifying or adding repository files, check `git status --short` and,
  when the worktree is clean, run `git pull --ff-only origin "$(git branch --show-current)"`.
  If local changes exist or the pull cannot fast-forward, stop and ask the user
  rather than stashing, merging, or overwriting changes.
- `herdr`, `lazygit`, `nvim`, and `scoop` are independently managed ignored
  directories. Do not modify them or run `git clean -fdx`.
- Keep WezTerm's `wezterm.config_builder()` construction and font fallback
  stack unless the user asks to change them.
- `autohotkey/vim_alt_for_win.ahk` targets AutoHotkey v2.
- On Windows, Yazi needs `YAZI_FILE_ONE` set to Git for Windows `file.exe`; see
  `yazi/README.md` before changing its integration.

## PowerToys

- `powertoys/manifest.json` defines the complete import set. After PowerToys or
  Command Palette UI changes, run `./powertoys/Sync-PowerToysSettings.ps1 -Mode Export`
  and review the resulting diff.
- Before importing, quit PowerToys and Command Palette, run the import with
  `-WhatIf`, then rerun without it. Do not copy live AppData files directly or
  bypass the manifest; the script removes machine-bound data and creates backups.

## Validation

- Use targeted checks for edited formats: `Invoke-ScriptAnalyzer -Path <file.ps1>`,
  `luac -p wezterm/wezterm.lua`, `jq . <file.json>`, `taplo check <file.toml>`,
  or `yq e '.' <file.yaml>`.
- For PowerShell syntax, use
  `pwsh -NoProfile -NoLogo -Command "Get-Command -Syntax .\path\to\script.ps1"`.
- Follow `.editorconfig`: LF by default, CRLF only for `*.bat` and `*.cmd`;
  4-space PowerShell/AutoHotkey, tabs for Lua, and 2-space JSON/TOML/YAML/Markdown.
- `.gitattributes` enforces LF text in Git. If `^M` appears, inspect with
  `git ls-files --eol` and follow `LINE_ENDINGS.md` for a targeted fix.
