# Displaying files and directories
## Powershell command
function lld { Get-ChildItem -Directory} # list directories only
function llf { Get-ChildItem -File} # list files only
function lla { Get-ChildItem -Attributes Hidden, !Hidden} # list hidden and non-hidden files

## eza command
function tree { & eza -h --icons=auto --tree --level=$args}

# copying current folder name
function cpwd { (pwd).path | Set-Clipboard }

# copying folder path of z destinztion
function cz {
  param ([string]$dir)
  $origianlPath = Get-Location
  z $dir
  (Get-Location).Path | Set-Clipboard
  Set-Location $origianlPath
}

# Git commands
function gs { & git status }
function gch { & git checkout $args }
function gac { & git add --all ; & git commit -m $args }

# App alias
Set-Alias -Name vi -Value nvim

# fzf commands
# using fzf find process ID and copy to clip board
# change [5] for ID column number accordingly 
function fzf_process { Get-Process | fzf | ForEach-Object { ($_ -split '\s+')[5].Trim() } | Set-Clipboard }
# Create stop process function
# Gets process ID and stop the process
function stopp {
        param( [int]$processId )
        try {
            # Attempt to stop the process
            Stop-Process -Id $processId -Force
            Write-Host "Process $processId has been terminated." -ForegroundColor Green
        }
        catch {
            # Handle errors
            Write-Host "Failed to terminate the process: $($_.Exception.Message)" -ForegroundColor Red
        }
}

# Stop a process from the searching result from 'fzf'
function fzf_stopp {
    # Get the selected process from fzf
    $selectedProcess = Get-Process | fzf

    # Extract Process ID and Name from the selected process
    $processId = ($selectedProcess -split '\s+')[5].Trim()  # Extract ID from the sixth column
    $processName = ($selectedProcess -split '\s+')[7].Trim()  # Extract Name from the seventh column
    Write-Host "Selected process is '$processName' (ID: $processId)."

    try {
        # Attempt to find the parent process
        $parentProcessId = (Get-Process -Id $processId).Parent.Id

        if ($null -eq $parentProcessId) {
            Write-Host "The selected process '$processName' (ID: $processId) does not have a parent process (it might be a root process)."
            $isParent = $true
        } else {
            $parentProcess = Get-Process -Id $parentProcessId
            $parentProcessName = $parentProcess.Name
            Write-Host "Parent process is '$parentProcessName' (ID: $parentProcessId)."
            $isParent = $false
        }

        # If the process is its own parent, terminate it directly
        if ($isParent) {
            Stop-Process -Id $processId -Force
            Write-Host "Selected process '$processName' (ID: $processId) has been terminated." -ForegroundColor Green
        } else {
            # Ask the user which process to terminate
            Write-Host "Which process would you like to terminate?"
            Write-Host "1. Selected process '$processName' (ID: $processId)"
            Write-Host "2. Parent process '$parentProcessName' (ID: $parentProcessId)"

            # Get user input
            $choice = Read-Host "Enter the number"

            # Terminate the chosen process
            if ($choice -eq "1") {
                Stop-Process -Id $processId -Force
                Write-Host "Selected process '$processName' (ID: $processId) has been terminated." -ForegroundColor Green
            } elseif ($choice -eq "2") {
                Stop-Process -Id $parentProcessId -Force
                Write-Host "Parent process '$parentProcessName' (ID: $parentProcessId) has been terminated." -ForegroundColor Green
            } else {
                Write-Host "Invalid choice. No process was terminated." -ForegroundColor Yellow
            }
        }
    }
    catch {
        # Handle errors
        Write-Host "Failed to terminate processes: $($_.Exception.Message)" -ForegroundColor Red
    }
}
