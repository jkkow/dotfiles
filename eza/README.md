# Eza

Shell aliases are provided by the Bash and PowerShell configurations. eza loads
a YAML theme named `theme.yml` from its configuration directory. The files in
`themes/` are available themes; link the selected theme to `theme.yml`.

## Windows

### Install

Run in an elevated PowerShell session:

```powershell
winget install --id eza-community.eza --exact --scope machine
```

### Configure

Set eza's configuration directory as a Windows user environment variable. New
terminals inherit it; restart the terminal application after running this
command:

```powershell
[Environment]::SetEnvironmentVariable('EZA_CONFIG_DIR', "$env:USERPROFILE\.config\eza", 'User')
```

Apply the setting to the current PowerShell session immediately:

```powershell
$env:EZA_CONFIG_DIR = "$env:USERPROFILE\.config\eza"
```

Select a theme by creating `theme.yml` as a symbolic link to a file in
`themes/`:

1. Choose a theme. Replace `tokyonight` with a filename from `themes/` without
   the `.yml` extension.

```powershell
$theme = 'tokyonight'
```

2. Remove the existing link or theme file.

```powershell
Remove-Item -LiteralPath "$env:USERPROFILE\.config\eza\theme.yml" -Force -ErrorAction Ignore
```

3. Create the link for the selected theme.

```powershell
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.config\eza\theme.yml" -Target "$env:USERPROFILE\.config\eza\themes\$theme.yml"
```

Creating symbolic links on Windows may require Developer Mode or an elevated
PowerShell session.

`EZA_COLORS` and `LS_COLORS` override `theme.yml`. Unset them when using a YAML
theme:

```powershell
Remove-Item Env:EZA_COLORS -ErrorAction Ignore
Remove-Item Env:LS_COLORS -ErrorAction Ignore
```

## Ubuntu

### Install

```sh
sudo apt update
sudo apt install -y eza
```

### Configure

Link a selected theme to `~/.config/eza/theme.yml`. Run these commands from
this `eza/` directory:

1. Choose a theme. Replace `tokyonight` with a filename from `themes/` without
   the `.yml` extension.

```sh
theme=tokyonight
```

2. Remove the existing link or theme file.

```sh
rm -f ~/.config/eza/theme.yml
```

3. Create the link for the selected theme.

```sh
ln -s "$(pwd)/themes/$theme.yml" ~/.config/eza/theme.yml
```

`EZA_COLORS` and `LS_COLORS` override `theme.yml`; unset them when using a YAML
theme.

## Omarchy

### Install

```sh
sudo pacman -S --needed eza
```

### Configure

Use the Ubuntu configuration instructions above.
