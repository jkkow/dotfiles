# PowerShell

This configuration applies on Windows with PowerShell 7. PowerShell does not load XDG configuration directories automatically, so `$PROFILE` must dot-source `initialize.ps1`.

## Install

```powershell
winget install --id Microsoft.PowerShell --exact --scope machine
```

## Configure

PowerShell reads `$PROFILE`, which is outside `~/.config`. Copy and run the entire block below in PowerShell. It displays the profile path, creates the profile when needed, and adds this repository initializer only once without replacing existing profile settings.

```powershell
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

Open a new PowerShell session or run `. $PROFILE` to reload it.
