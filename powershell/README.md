# PowerShell

Windows PowerShell 7 profile. Install `eza`, `fzf`, `nvim`, `ripgrep`, `starship`,
`yazi`, and `zoxide` before loading it.

## Install and Configure

Paste this into PowerShell after cloning the repository:

```powershell
$ErrorActionPreference = "Stop"
winget install --id Microsoft.PowerShell --exact --scope machine

$dotfilesInitializer = Join-Path $HOME ".config\powershell\initialize.ps1"
if (-not (Test-Path -LiteralPath $dotfilesInitializer)) {
    throw "Dotfiles initializer was not found: $dotfilesInitializer"
}

$profileDirectory = Split-Path -Parent $PROFILE
New-Item -ItemType Directory -Path $profileDirectory -Force | Out-Null
New-Item -ItemType File -Path $PROFILE -Force | Out-Null

$sourceLine = '. "{0}"' -f $dotfilesInitializer
if (-not (Select-String -LiteralPath $PROFILE -SimpleMatch $dotfilesInitializer -Quiet)) {
    Add-Content -LiteralPath $PROFILE -Value $sourceLine
    Write-Host "Added dotfiles initializer to $PROFILE"
} else {
    Write-Host "Dotfiles initializer is already registered in $PROFILE"
}

Write-Host "PowerShell profile: $PROFILE"
```

Open a new PowerShell 7 session or run `. $PROFILE`. If script execution is
blocked, run `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` once.
