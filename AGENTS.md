# Agent Notes for This Repo

High-signal guidance for OpenCode/Codex sessions in `dotfiles`.

## Scope and Entry Points

- This is a cross-platform dotfiles repo for Windows, Ubuntu, and Omarchy, not an app build/test repo.
- The repository is cloned directly into `$HOME/.config`; it has no installer.
- PowerShell runtime entrypoint: `powershell/initialize.ps1` (dot-sources the sibling alias and module scripts).
- WezTerm entrypoint: `wezterm/wezterm.lua`.

## Safety and Workflow Constraints

- Do not add package-installation or configuration-linking automation without an explicit request.
- Do not modify independently managed directories ignored by `.gitignore`.
- Do not use `git clean -fdx`; it removes independently managed ignored directories.

## Validation Commands (Targeted)

- PowerShell: `Invoke-ScriptAnalyzer -Path <file.ps1>`
- PowerShell syntax load check: `pwsh -NoProfile -NoLogo -Command "Get-Command -Syntax .\path\to\script.ps1"`
- WezTerm Lua syntax: `luac -p .\wezterm\wezterm.lua`
- JSON: `jq . <file.json>`
- TOML: `taplo check <file.toml>`
- YAML: `yq e '.' <file.yaml>`

## File/Style Rules That Matter Here

- Follow `.editorconfig`: LF by default, CRLF only for `*.bat`/`*.cmd`; 4-space indent for `*.ps1`/`*.ahk`; tabs in `*.lua`; 2-space for `*.md`/`*.yml`/`*.yaml`/`*.json`/`*.toml`.
- Follow `.gitattributes`: text normalized to LF; `*.bat`/`*.cmd` are CRLF; common binaries are marked binary.
- If `^M` appears, use `LINE_ENDINGS.md` workflow (`git ls-files --eol` first, then targeted fix).

## Tool-Specific Gotchas

- WezTerm: keep `config` built via `wezterm.config_builder()` pattern and preserve configured font fallback stack unless user asks to change it.
- AutoHotkey: primary script is `autohotkey/vim_alt_for_win.ahk` and targets AutoHotkey v2 (`#Requires AutoHotkey v2.0`).
- Yazi on Windows may require `YAZI_FILE_ONE` pointing to Git for Windows `file.exe` (see `yazi/README.md`).
