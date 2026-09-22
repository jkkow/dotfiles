[Console]::InputEncoding = [System.Text.UTF8Encoding]::new()
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
$OutputEncoding = [System.Text.UTF8Encoding]::new()

# Windows Terminal can inherit WezTerm installer variables from an older session.
# Preserve them in WezTerm itself, but prevent Yazi from selecting WezTerm's image adapter in Windows Terminal.
if ($env:WT_SESSION -and -not $env:WEZTERM_PANE) {
    Remove-Item Env:WEZTERM_CONFIG_DIR, Env:WEZTERM_CONFIG_FILE, Env:WEZTERM_EXECUTABLE, Env:WEZTERM_EXECUTABLE_DIR, Env:WEZTERM_UNIX_SOCKET -ErrorAction SilentlyContinue
}

[System.Threading.Thread]::CurrentThread.CurrentCulture = 'en-US'
[System.Threading.Thread]::CurrentThread.CurrentUICulture = 'en-US'
[System.Globalization.CultureInfo]::DefaultThreadCurrentCulture = 'en-US'
[System.Globalization.CultureInfo]::DefaultThreadCurrentUICulture = 'en-US'

. (Join-Path $PSScriptRoot "powershell_alias.ps1")
. (Join-Path $PSScriptRoot "setup_modules.ps1")
