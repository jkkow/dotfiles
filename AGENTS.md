# Agent Notes for This Repo

High-signal guidance for OpenCode/Codex sessions in `dotfiles`.

## Scope and Entry Points

- This is a Windows-first dotfiles repo, not an app build/test repo.
- Main orchestrator: `installation/install.ps1`.
- PowerShell runtime entrypoint: `powershell/Microsoft.PowerShell_profile.ps1` (dot-sources `powershell_alias.ps1` and `setup_modules.ps1` from `$HOME\.config\powershell`).
- WezTerm entrypoint: `wezterm/wezterm.lua`.

## Commands You Should Not Guess

- Install all managed tools: `pwsh .\installation\install.ps1 -All`
- Install specific tools: `pwsh .\installation\install.ps1 -Tools powershell,eza,starship,wezterm,yazi,zed,zoxide`
- Keep elevated installer console open: add `-PauseAtEnd`
- Re-render an install report: `pwsh .\installation\report-install-summary.ps1 -SummaryPath <path-to-json>`

## Safety and Workflow Constraints

- `install.ps1` auto-elevates (`RunAs`) and installs packages with `winget --scope machine` (PowerShell installer can fall back to default scope); do not run full installer unless the user explicitly asks.
- Installer writes runtime artifacts under `installation/logs/`; avoid editing/committing those logs unless the task is specifically about installer logs.
- WezTerm installer intentionally uses nightly (`wez.wezterm.nightly`) to satisfy min-version policy.
- Yazi installer also installs required dependencies (`ffmpeg`, `7zip`, `jq`, `poppler`, `fd`, `ripgrep`, `fzf`, `zoxide`, `imagemagick`).

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
