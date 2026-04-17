# set yazi wrapper y 
function y {
	$tmp = (New-TemporaryFile).FullName
	yazi.exe $args --cwd-file="$tmp"
	$cwd = Get-Content -Path $tmp -Encoding UTF8
	if ($cwd -ne $PWD.Path -and (Test-Path -LiteralPath $cwd -PathType Container)) {
		Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
	}
	Remove-Item -Path $tmp
}

######### Zoxide Initialization and CD Command Hook ##################
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
#################################################################

Set-PsReadLineOption -EditMode Vi
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $OnViModeChange

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

$ENV:STARSHIP_CONFIG = "$Home\.config\starship\starship.toml"
if (Test-Path -LiteralPath $ENV:STARSHIP_CONFIG) {
    try {
        Invoke-Expression (& starship init powershell)
    }
    catch {
        Write-Warning "Starship initialization failed: $($_.Exception.Message)"
    }
}
else {
    Write-Warning "Starship config file not found: $ENV:STARSHIP_CONFIG"
}
