# Agent Directives (`AGENTS.md`)

This file contains operational instructions for autonomous coding agents (like Cursor, GitHub Copilot Workspace, OpenCode, and Devin) operating in this repository.

## Repository Context

This is a cross-platform, Windows-first Dotfiles repository prioritizing performance, readability, and modern CLI tools. The primary configurations cover WezTerm, Yazi, GlazeWM, PowerShell, Starship, AutoHotkey, and Eza.

There are no formal `.cursorrules` or `.github/copilot-instructions.md` files at present. Agents must treat this document as the ultimate source of truth for coding standards and validation within this workspace.

---

## 1. Build, Lint, and Test Commands

Because this is a configuration repository rather than a compiled software application, the concepts of "build" and "test" map to **validation, linting, and sandbox execution**.

### Global Checks & Linting

- **PowerShell Validation:** Run `Invoke-ScriptAnalyzer -Path <file.ps1>` using PSScriptAnalyzer. Address any Warnings or Errors.
- **Lua Validation (WezTerm):** Run `luac -p <file.lua>` (if Lua is installed locally) or rely on `selene` / `luacheck` if available in the environment.
- **Bash Validation:** Run `shellcheck <script.sh>` for bash scripts.
- **JSON/TOML/YAML Validation:** Use `jq . <file.json>`, `taplo check <file.toml>`, or `yq e '.' <file.yaml>` to catch syntax errors before committing.

### Running a Single "Test"

Agents must avoid modifying the user's active session state and instead sandbox changes. To "test" a single script or profile change safely:

**PowerShell (`.ps1`) Scripts:**

- **Unit Test Execution:** `pwsh -NoProfile -NonInteractive -Command "& { . .\path\to\script.ps1; <Call-Function> }"`
- **Syntax Check Only:** `pwsh -NoProfile -NoLogo -Command "Get-Command -Syntax .\path\to\script.ps1"`
- **Performance Test:** Measure load time via `Measure-Command { pwsh -NoProfile -Command ". .\path\to\script.ps1" }`

**WezTerm (`.lua`) Configuration:**

- WezTerm automatically reloads when `wezterm.lua` is saved. When editing `wezterm.lua`, ensure syntactical correctness before writing the file to prevent locking up the user's active terminal.
- **Testing via CLI:** `wezterm cli spawn -- <command>` or `wezterm start --always-new-process`.

**AutoHotkey (`.ahk`) Scripts:**

- **Manual Reload:** Testing requires reloading the script via the system tray or command line: `AutoHotkey.exe \path\to\script.ahk /restart`.

---

## 2. Code Style Guidelines

Maintain the high-performance, modular nature of these dotfiles. Slow shell startups are unacceptable.

### Imports & Modularity

- **PowerShell:** Use dot-sourcing (`. .\script.ps1`) for local files within the `powershell/` directory. For installed modules, prefer relying on module autoloading over explicit `Import-Module` unless modifying the `$env:PSModulePath` is necessary.
- **Lua:** Use `local mod = require("mod")` at the top of files. Organize large configurations into multiple files returning tables if the main config grows too large.
- **Bash:** Use `source ./script.sh` or `. ./script.sh`.

### Formatting & Indentation

- **PowerShell:** 4 spaces for indentation. Opening braces `{` on the same line as the statement.
- **Lua:** Tabs or 4 spaces depending on the existing file convention (strictly adhere to `wezterm.lua`'s indentation).
- **AutoHotkey:** 4 spaces. Opening braces `{` on the same line as the hotkey definition.
- **TOML/YAML/JSON:** 2 spaces (or tabs if existing, e.g., in `yazi.toml`).
- **Trailing Whitespace:** Remove trailing whitespace in all files. Ensure a single newline at the end of every file.

### Types and Signatures

- **PowerShell:**
  - Use strongly typed parameters in `param()` blocks for all new functions (e.g., `[string]$Level`, `[int]$Count`).
  - Return explicit types where necessary and avoid implicit pipeline output that pollutes results.
  - Add `[CmdletBinding()]` for complex scripts that require advanced parameters.
- **Lua:**
  - Document parameter shapes using comments if complex tables are passed.

### Naming Conventions

- **PowerShell Functions:**
  - For internal/utility functions, use standard `Verb-Noun` format (e.g., `Get-CustomDir`).
  - For aliases intended for CLI usage (e.g., wrappers for `eza`, `yazi`), use lowercase short names (e.g., `ls`, `y`, `z`).
- **PowerShell Variables:** Use `PascalCase` (e.g., `$Level`, `$PWD`) for script-level variables. Standard `$camelCase` or all lowercase is acceptable for local loop iterators.
- **Lua Variables/Functions:** `snake_case` (e.g., `default_prog`, `window_decorations`).
- **File Names:**
  - `snake_case.lua` for Lua files.
  - `snake_case.ps1` for PowerShell scripts (e.g., `powershell_alias.ps1`, `setup_modules.ps1`).
  - `.kebab-case.toml` or `snake_case.toml` for TOML/YAML depending on the tool's standard.

### Error Handling

- **PowerShell:**
  - Use `-ErrorAction SilentlyContinue` for commands that might fail but shouldn't halt profile loading (e.g., `Remove-Item Alias:\cd -Force -ErrorAction SilentlyContinue`).
  - Use `try { ... } catch { Write-Warning $_ }` for external calls or API interactions so the shell still loads if a tool is missing.
- **Lua (WezTerm):**
  - Use `pcall(require, "module_name")` if depending on external Lua modules that might not be installed, avoiding startup crashes.
- **Bash:**
  - Check exit codes (`if [ $? -ne 0 ]; then`) or use `set -e` carefully in scripts that aren't sourced in `.bashrc`.

### Comments and Documentation

- **Explain the "Why":** Dotfiles often contain workarounds for OS quirks (e.g., Windows pathing, overriding default aliases). Leave comments explaining *why* a hack exists.
  - *Example:* `# This ensures that our custom 'function cd' is the one that executes.`
- Avoid stating the obvious (e.g., do not write `# this is a loop`).

---

## 3. Tool-Specific Agent Instructions

### Yazi (`yazi/`)

- Adhere to TOML syntax strictly. Verify changes to Yazi flavors or plugins don't break existing keybindings in `yazi.toml` or `theme.toml`.
- When updating Yazi, verify Windows-specific shell wrappers (like the PowerShell `y` function) still safely change directories upon exit.

### WezTerm (`wezterm/`)

- All config blocks must append to the main `config` table or use `wezterm.config_builder()`.
- Prioritize Nerd Fonts with Fallbacks (currently configured for `JetBrainsMono Nerd Font` and `D2CodingLigature Nerd Font`). Do not change these defaults without user consent.

### GlazeWM (`glazewm/`)

- Written in YAML. Watch out for strict indentation (typically 2 spaces).
- Ensure hotkeys do not conflict with system defaults (e.g., Win+D, Win+E) unless explicitly requested by the user.

### AutoHotkey (`autohotkey/`)

- Any new shortcuts should be thoroughly documented inline.
- The primary script (`vim_alt_for_win.ahk`) maps `<Ctrl>` to mimic `<Alt>` or specific Vim-like motions (e.g., `^+h` for `{Left}`). Stick to this paradigm and `#Requires AutoHotkey v2.0`.

