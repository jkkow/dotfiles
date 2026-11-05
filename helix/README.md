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

For verification, `hx --health python` should find both language servers. Open a
Python project from its root, introduce a type error to check BasedPyright's
diagnostics, and run `:format` on unformatted code to check Ruff. BasedPyright
uses its Python environment discovery and project settings; a project's virtual
environment must be discoverable for its packages to resolve.
