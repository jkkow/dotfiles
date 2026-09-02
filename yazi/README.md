# Yazi

Yazi is the terminal file manager used by this setup.

## Install and Configure

On Windows, paste this after cloning the repository. It installs Yazi and the
core preview tools, restores the pinned flavors, and configures Git for
Windows' `file.exe` for MIME detection:

```powershell
winget install --id Gyan.FFmpeg --exact --scope machine
winget install --id 7zip.7zip --exact --scope machine
winget install --id oschwartz10612.Poppler --exact --scope machine
winget install --id ImageMagick.ImageMagick --exact --scope machine
winget install --id sxyazi.yazi --exact --scope machine
winget install --id Git.Git --exact --scope machine
$yaziConfig = Join-Path $HOME ".config\yazi"
$gitFile = Join-Path $env:ProgramFiles "Git\usr\bin\file.exe"

if (-not (Test-Path -LiteralPath $yaziConfig -PathType Container) -or
    -not (Test-Path -LiteralPath $gitFile -PathType Leaf)) {
    throw "Clone the repository and install Git for Windows before continuing."
}
[Environment]::SetEnvironmentVariable("YAZI_CONFIG_HOME", $yaziConfig, "User")
[Environment]::SetEnvironmentVariable("YAZI_FILE_ONE", $gitFile, "User")
ya pkg install
```

Restart the terminal after setting the variables. `jq`, `fd`, `fzf`, `nvim`,
`resvg`, `ripgrep`, and `zoxide` are optional integrations. On Linux, install
Yazi and preview tools with the distribution package manager; cloning to
`~/.config` is sufficient.
