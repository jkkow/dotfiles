# PowerShell

PowerShell is the main shell profile in this dotfiles repository.

## Install

```powershell
winget install --id Microsoft.PowerShell --exact --scope machine
scoop install main/pwsh

# Or via this dotfiles installer
pwsh .\installation\install.ps1 -Tools powershell
```

## Configure

This repo links the whole `powershell` folder.

- source: `powershell/`
- target: `$HOME\.config\powershell`

```powershell
New-Item -ItemType Directory -Path "$HOME\.config" -Force
New-Item -ItemType SymbolicLink -Path "$HOME\.config\powershell" -Target "C:\path\to\dotfiles\powershell" -Force
```

PowerShell profile entry point is managed by this file:

- `$PROFILE` -> loads `Microsoft.PowerShell_profile.ps1`
