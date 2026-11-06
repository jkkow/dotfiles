# Yazi

Terminal file manager configuration with pinned Nord and Catppuccin flavors.

## Windows

### Install

Run in an elevated PowerShell session:

```powershell
winget install --id sxyazi.yazi --exact --scope machine
winget install --id Git.Git --exact --scope machine
winget install --id Gyan.FFmpeg --exact --scope machine
winget install --id 7zip.7zip --exact --scope machine
winget install --id oschwartz10612.Poppler --exact --scope machine
winget install --id ImageMagick.ImageMagick --exact --scope machine
winget install --id Neovim.Neovim --exact --scope machine
```

Optional integrations: `jq`, `fd`, `fzf`, `resvg`, `ripgrep`, and `zoxide`.

### Configure

Open a new terminal after installing, then run:

```powershell
$yaziConfig = Join-Path $HOME ".config\yazi"
$gitFile = Join-Path $env:ProgramFiles "Git\usr\bin\file.exe"
if (-not (Test-Path -LiteralPath $yaziConfig -PathType Container) -or
    -not (Test-Path -LiteralPath $gitFile -PathType Leaf)) {
    throw "Clone the repository and install Git for Windows before continuing."
}

[Environment]::SetEnvironmentVariable("YAZI_CONFIG_HOME", $yaziConfig, "User")
[Environment]::SetEnvironmentVariable("YAZI_FILE_ONE", $gitFile, "User")
$env:YAZI_CONFIG_HOME = $yaziConfig
$env:YAZI_FILE_ONE = $gitFile
ya pkg install
```

### Image Preview

Yazi previews images in Windows Terminal through Sixel and in WezTerm through
its inline-image protocol. Start Yazi from the configured PowerShell profile;
the profile prevents inherited `WEZTERM_*` variables from making Windows
Terminal appear to be WezTerm.

To check the selected adapter, run `ya env` in the terminal that launches
Yazi. Windows Terminal should report `Brand.from_env: Some(Microsoft)` and
`Drivers.matches: Sixel`. WezTerm should report `Brand.from_env: Some(WezTerm)`.
Fully restart Windows Terminal after changing persistent environment variables.

When native Windows Herdr runs inside Windows Terminal, its inner terminal can
advertise Kitty graphics even though Windows Terminal cannot render Herdr's
Kitty output. The `herdr-image` previewer uses Chafa's colored character
symbols for images only in Windows Herdr panes. Other terminals retain Yazi's
normal image previewers. Install Chafa for the current user:

```powershell
winget install --id hpjansson.Chafa --exact --scope user
```

Ensure `chafa --version` works in the existing Herdr pane; restart its shell
or update its PATH if necessary. Restart Yazi and select a PNG or JPEG to check
the symbol preview. Chafa's supported image formats depend on its build; other
image types may show an error. Video, PDF, and font previews still use Yazi's
normal graphics adapter and are not covered by this workaround.

## Ubuntu

### Install

```sh
sudo apt update
sudo apt install -y yazi file ffmpeg p7zip-full poppler-utils imagemagick neovim
```

### Configure

```sh
cd "$HOME/.config/yazi"
ya pkg install
```

## Omarchy

### Install

```sh
sudo pacman -S --needed yazi file ffmpeg 7zip poppler imagemagick neovim
```

### Configure

```sh
cd "$HOME/.config/yazi"
ya pkg install
```
