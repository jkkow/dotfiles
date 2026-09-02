# PowerShell

PowerShell 7 profile configuration for Windows.

## Windows

### Install

Run in an elevated PowerShell session:

```powershell
winget install --id Microsoft.PowerShell --exact --scope machine
winget install --id eza-community.eza --exact --scope machine
winget install --id junegunn.fzf --exact --scope machine
winget install --id Neovim.Neovim --exact --scope machine
winget install --id BurntSushi.ripgrep.MSVC --exact --scope machine
winget install --id Starship.Starship --exact --scope machine
winget install --id sxyazi.yazi --exact --scope machine
winget install --id ajeetdsouza.zoxide --exact --scope machine
```

### Configure

```powershell
$dotfilesInitializer = Join-Path $HOME ".config\powershell\initialize.ps1"
if (-not (Test-Path -LiteralPath $dotfilesInitializer -PathType Leaf)) {
    throw "Dotfiles initializer was not found: $dotfilesInitializer"
}

$profileDirectory = Split-Path -Parent $PROFILE
New-Item -ItemType Directory -Path $profileDirectory -Force | Out-Null
New-Item -ItemType File -Path $PROFILE -Force | Out-Null
$sourceLine = '. "{0}"' -f $dotfilesInitializer
if (-not (Select-String -LiteralPath $PROFILE -SimpleMatch $dotfilesInitializer -Quiet)) {
    Add-Content -LiteralPath $PROFILE -Value $sourceLine
}
. $PROFILE
```

If script execution is blocked, run
`Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` once.
