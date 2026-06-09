[Console]::InputEncoding = [System.Text.UTF8Encoding]::new()
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
$OutputEncoding = [System.Text.UTF8Encoding]::new()

[System.Threading.Thread]::CurrentThread.CurrentCulture = 'en-US'
[System.Threading.Thread]::CurrentThread.CurrentUICulture = 'en-US'
[System.Globalization.CultureInfo]::DefaultThreadCurrentCulture = 'en-US'
[System.Globalization.CultureInfo]::DefaultThreadCurrentUICulture = 'en-US'

# [previous code] - SSH fails
# . $env:USERPROFILE\.config\powershell\powershell_alias.ps1
# . $env:USERPROFILE\.config\powershell\setup_modules.ps1

# ----------------------------------------------------------------
# [modified code] - direct path to the configuraion files
# ----------------------------------------------------------------

# ex: C:\Users\jkkow\config\powershell
# manage powershell dotfiles separately
$RealConfigPath = "$env:USERPROFILE\.config\powershell" 

# check if the path exist
if (Test-Path $RealConfigPath) {
    . "$RealConfigPath\powershell_alias.ps1"
    . "$RealConfigPath\setup_modules.ps1"
} else {
    Write-Warning "SSH Profile Load Error: 원본 설정 경로를 찾을 수 없습니다. ($RealConfigPath)"
}
