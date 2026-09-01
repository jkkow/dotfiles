[Console]::InputEncoding = [System.Text.UTF8Encoding]::new()
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
$OutputEncoding = [System.Text.UTF8Encoding]::new()

[System.Threading.Thread]::CurrentThread.CurrentCulture = 'en-US'
[System.Threading.Thread]::CurrentThread.CurrentUICulture = 'en-US'
[System.Globalization.CultureInfo]::DefaultThreadCurrentCulture = 'en-US'
[System.Globalization.CultureInfo]::DefaultThreadCurrentUICulture = 'en-US'

. (Join-Path $PSScriptRoot "powershell_alias.ps1")
. (Join-Path $PSScriptRoot "setup_modules.ps1")
