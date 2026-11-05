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
