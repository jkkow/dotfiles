# Helix

The global configuration is stored in `helix/config.toml` in this repository.
On Linux, Helix reads it from `~/.config/helix/config.toml` by default.

On Windows, Helix reads its configuration from `%APPDATA%\helix` by default.
To use the repository configuration, create a directory symbolic link in
PowerShell after checking that the destination does not already exist:

```powershell
New-Item -ItemType SymbolicLink -Path "$env:APPDATA\helix" `
    -Target "$HOME\.config\helix"
```

The directory link also makes other configuration files, such as
`languages.toml`, available to Helix. If the destination already exists,
inspect and preserve any files it contains before replacing it with the link.
Creating symbolic links may require Windows Developer Mode or an elevated
PowerShell. Restart Helix or run `:config-reload` after editing `config.toml`.

## Appearance

The configuration uses `themes/catppuccin_mocha_transparent.toml`, which inherits
Helix's bundled Catppuccin Mocha theme as an approximation of the Neovim
Catppuccin setup. The editor background, popups, help, and unselected menus use
the terminal's default background; selected menu entries retain a contrasting
background for readability. Transparency depends on the terminal's own
background and opacity settings.

Line numbers are relative, scrolloff is 15 lines, and soft wrapping retains up
to 40 columns of indentation. Restart Helix after changing the theme file.

## Editing keys

In insert mode, `lk` returns to normal mode. Because `l` is a key-sequence
prefix, Helix waits for the next key before inserting it. In Helix 25.07.1,
typing `la` inserts both characters, even after a pause; typing `lk` instead
exits insert mode without inserting those letters. This shortcut therefore
conflicts with typing a literal `lk`. If `l` is pending, the first `Esc`
resolves the pending input and another `Esc` exits insert mode.

Other custom Neovim workflows use Helix defaults where possible:

- `%` selects the whole file; `Ctrl-a` retains its default increment action.
- `Alt-d` deletes the current selection without yanking. Helix's `x` selects a
  line rather than deleting a character; select the desired text first.
- `[d` and `]d` move between diagnostics; `Space d` and `Space D` open document
  and workspace diagnostic pickers. They do not reproduce Neovim's diagnostic
  floating window or location list exactly.
- `Space y` and `Space p` use the system clipboard. The SSH-specific Neovim
  OSC 52 mapping is a separate workflow and has not been verified here.

Harpoon's saved quick menu, the Snacks terminal, and the OpenCode editor
integration do not have equivalent bindings in this configuration. `Space b`
opens a buffer picker, but it is not a persistent Harpoon list.

## Markdown, Quarto, and R Markdown

Install Panache as a standalone tool with `uv tool install panache-cli`. The
`panache` command must be on the PATH inherited by Helix; `uv tool dir --bin`
shows the tool executable directory. Confirm with `panache --version` and
`hx --health markdown`, `hx --health quarto`, and `hx --health rmarkdown`.
Restart Helix after changing `languages.toml` or its inherited PATH.

Open Helix from the project root, for example `hx path/to/document.qmd` from
that directory. The language settings include `.panache.toml`, `panache.toml`,
`_quarto.yml`, `.quarto`, and `.git` as root markers. Root selection is not
identical to Neovim's: in a Helix 25.07.1 test launched from a nested directory,
an ancestor `.panache.toml` alone did not become the LSP root. Helix uses the
PATH command and does not implement Neovim's project-local executable lookup.

Panache handles `.md`, `.qmd`, `.rmd`, and `.Rmd` diagnostics and navigation;
Markdown's default Marksman and Markdown Oxide servers are replaced to avoid
duplicate Markdown diagnostics. R Markdown retains Helix's default R server
alongside Panache; it also needs `R` and its language server to be installed.
When available, its interactions with Panache should be checked per project.
Try a missing footnote and `Space d`, or place the cursor on a defined footnote
reference and press `gd`.

Panache formatting is excluded from Helix LSP formatting, matching the Neovim
Panache override. `:format` will not use Panache for these documents; another
configured formatter or the retained R server may have its own formatting
behavior. This is separate from Python's manually invoked Ruff formatting below.

## Python

Install the language servers as standalone `uv` tools:

```sh
uv tool install basedpyright
uv tool install ruff
```

Helix starts `basedpyright-langserver` for Python analysis and `ruff server` for
formatting. Python uses four-space indentation. Formatting is not automatic on
save; run `:format` in a Python buffer when needed. Ruff diagnostics are not
enabled in this configuration.

Both commands must be on the PATH inherited by Helix. Check the tool executable
directory with `uv tool dir --bin`. For the current PowerShell session only, add
it before starting Helix:

```powershell
$env:PATH = "$(uv tool dir --bin);$env:PATH"
hx --health python
hx path/to/file.py
```

On POSIX shells, use `export PATH="$(uv tool dir --bin):$PATH"` for the current
session. If Helix is launched from another application, that application must
also supply the PATH. Persistent PATH configuration is a separate choice.
Helix resolves the server commands through its inherited PATH; it does not use
Neovim's project `.venv`-first tool resolver. Activate a project environment or
otherwise adjust PATH before launching Helix if its server tools should win.

For verification, `hx --health python` should find both language servers. Open a
Python project from its root, introduce a type error to check BasedPyright's
diagnostics, and run `:format` on unformatted code to check Ruff. BasedPyright
uses its Python environment discovery and project settings; a project's virtual
environment must be discoverable for its packages to resolve.
This interpreter and package discovery is separate from choosing the server
executables on PATH.
