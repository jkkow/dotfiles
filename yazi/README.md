# Yazi

Yazi is a terminal file manager used in this dotfiles setup.

## Install

### winget

```powershell
winget install --id Gyan.FFmpeg --exact --scope machine
winget install --id 7zip.7zip --exact --scope machine
winget install --id jqlang.jq --exact --scope machine
winget install --id oschwartz10612.Poppler --exact --scope machine
winget install --id sharkdp.fd --exact --scope machine
winget install --id BurntSushi.ripgrep.MSVC --exact --scope machine
winget install --id junegunn.fzf --exact --scope machine
winget install --id ajeetdsouza.zoxide --exact --scope machine
winget install --id ImageMagick.ImageMagick --exact --scope machine
winget install --id sxyazi.yazi --exact --scope machine
```

### Scoop

```powershell
scoop install main/ffmpeg main/7zip main/jq main/poppler main/fd main/ripgrep main/fzf main/zoxide main/imagemagick main/yazi
```

## Required dependencies

| Tool | winget ID | Scoop package | Why it is needed |
| --- | --- | --- | --- |
| FFmpeg | `Gyan.FFmpeg` | `main/ffmpeg` | Video and audio preview, metadata extraction. |
| 7-Zip | `7zip.7zip` | `main/7zip` | Archive listing and extraction support. |
| jq | `jqlang.jq` | `main/jq` | Pretty-printing and previewing JSON files. |
| Poppler | `oschwartz10612.Poppler` | `main/poppler` | PDF text and metadata preview tools. |
| fd | `sharkdp.fd` | `main/fd` | Fast file search used by workflows and plugins. |
| ripgrep | `BurntSushi.ripgrep.MSVC` | `main/ripgrep` | Fast content search and filtering. |
| fzf | `junegunn.fzf` | `main/fzf` | Fuzzy file and path selection integration. |
| zoxide | `ajeetdsouza.zoxide` | `main/zoxide` | Directory jumping integration. |
| ImageMagick | `ImageMagick.ImageMagick` | `main/imagemagick` | Image conversion and thumbnail pipeline support. |

## file(1) requirement on Windows

Yazi relies on file(1) to detect the mime-type of files, and the easiest and most reliable way to get it on Windows is to install Git for Windows and use the `file.exe` that comes with it.

Install Git for Windows by running the official installer, or through your package manager of choice.

To allow Yazi to use file(1), set the `YAZI_FILE_ONE` environment variable to `<Git_Installed_Directory>\usr\bin\file.exe`. This path depends on how you installed Git:

- Installer-based Git for Windows: `C:\Program Files\Git\usr\bin\file.exe`
- Scoop-based Git: `C:\Users\<Username>\scoop\apps\git\current\usr\bin\file.exe`

Yazi defaults to `%APPDATA%\yazi\config` on Windows. Configure its config directory and Git-provided `file.exe` by copying and running this block after cloning the repository:

```powershell
$yaziConfig = Join-Path $HOME ".config\yazi"
$gitFile = "C:\Program Files\Git\usr\bin\file.exe"

if (-not (Test-Path -LiteralPath $yaziConfig -PathType Container)) {
    throw "Yazi configuration directory was not found: $yaziConfig"
}
if (-not (Test-Path -LiteralPath $gitFile -PathType Leaf)) {
    throw "Git for Windows file.exe was not found: $gitFile"
}

[Environment]::SetEnvironmentVariable("YAZI_CONFIG_HOME", $yaziConfig, "User")
[Environment]::SetEnvironmentVariable("YAZI_FILE_ONE", $gitFile, "User")
```

Close all WezTerm windows and start a new one after changing these variables. Installing `file` via Scoop or Chocolatey is not recommended because those builds can fail on Unicode filenames and can miss required parameters.

## Windows preview checks

Yazi needs `file.exe` for MIME detection and Poppler's `pdftoppm.exe` for PDF previews. Verify both in a new terminal:

```powershell
$env:YAZI_CONFIG_HOME
$env:YAZI_FILE_ONE
Get-Command pdftoppm
ya env
```

Use the latest WezTerm nightly for image previews. If previews remain stale after correcting the environment variables, run `yazi --clear-cache` and start Yazi again.

## Configure

On Linux, cloning this repository into `~/.config` places the Yazi configuration at its standard XDG path. Install Yazi and its preview dependencies with the distribution package manager.
