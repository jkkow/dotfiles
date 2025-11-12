$env:_ZO_ECHO = '1'
Invoke-Expression (& { (zoxide init powershell | Out-String) })

Import-Module PSReadLine
# enable Vim on the shell and as editor
$OnViModeChange = [scriptblock]{
  if ($args[0] -eq 'Command') {
      # Set the cursor to a blinking block.
      Write-Host -NoNewLine "`e[2 q"
  }
  else {
      # Set the cursor to a blinking line.
      Write-Host -NoNewLine "`e[5 q"
  }
}

Set-PsReadLineOption -EditMode Vi
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $OnViModeChange

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

Invoke-Expression (&starship init powershell)
$ENV:STARSHIP_CONFIG = "$Home\.config\starship\starship.toml" # set Starship configuration file location
