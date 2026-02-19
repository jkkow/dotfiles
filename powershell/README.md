# PowerShell 7 Configuration

## Update Main PowerShell Profile

You can check the location of PowerShell Main Profile by typing,

```powershell
$PROFILE
```

Default location is

- `$env:USERPROFILE\OneDrive\Documents\PowerShell\Microsoft.PowerShell_profile.ps1` or
- `$env:USERPROFILE\Documents\PowerShell\Microsoft.Powershell_profile.ps1`

Overwrite the file with the file `Microsoft.PowerShell_profile.ps1
` in this repo. Here, we calls configuration script `powershell_alias.ps1` and `setup_modules.ps1`.

## Set Symbolic Link

Move to `$HOME\.config\` and make the Symbolic Link for PowerSehll.

```powershell
New-Item -ItemType SymbolicLink -Path ".\powershell\" -Target "path\to\dotfiles\powershell"
```
