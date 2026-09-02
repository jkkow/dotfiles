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
