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

You can also install this via the repo installer:

```powershell
pwsh .\installation\install.ps1 -Tools yazi
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

Restart your terminal after setting `YAZI_FILE_ONE`.

This is the only recommended way. Installing `file` via Scoop or Chocolatey is not recommended because those builds can fail on Unicode filenames and can miss required parameters.

Most users already have Git installed, and Yazi is also hosted via Git, so this usually is not an issue. If you really do not want to install Git, the `mime-ext.yazi` plugin can help because it uses an extension database instead of relying on the file(1) binary.

## Configure

This repo links the entire Yazi config folder.

- source: `yazi/`
- target: `$HOME\.config\yazi`

```powershell
New-Item -ItemType Directory -Path "$HOME\.config" -Force
New-Item -ItemType SymbolicLink -Path "$HOME\.config\yazi" -Target "C:\path\to\dotfiles\yazi" -Force
```
