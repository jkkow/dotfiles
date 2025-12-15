# Zoxide Initialization and CD Command Hook
# This code block explicitly defines z and cd functions
# to ensure auto-indexing works in PowerShell.

# This ensures that our custom 'function cd' is the one that executes.
Remove-Item Alias:\cd -Force -ErrorAction SilentlyContinue

# Define the core zoxide function (handles the 'z' command)
function z {
    # 1. Find the path, cleaning up any trailing spaces/newlines
    $path = (zoxide query @args | Out-String).Trim()
    Set-Location -Path $path
}

# Redefine the 'cd' command (hooks the original Set-Location)
# This part is crucial for automatically adding directories to the database.
function cd {
    Set-Location @args | Out-Null
    & zoxide add .
}

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
