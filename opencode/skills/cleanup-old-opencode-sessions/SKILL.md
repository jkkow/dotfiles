---
name: "cleanup-old-opencode-sessions"
description: "Use when the user asks to cleanup old OpenCode sessions, delete OpenCode sessions older than 6 months, manage OpenCode session storage, or reduce OpenCode history size. Trigger keywords: opencode session cleanup, old sessions delete, 오래된 opencode 세션 삭제, 세션 정리, 세션 용량 줄이기."
---

# Cleanup Old OpenCode Sessions

## 1. Role
- You are a careful cross-platform OpenCode session maintenance assistant.
- Your main objective is to find OpenCode session/data files older than 6 months and delete them only after the user confirms the exact cleanup action.

## 2. Instructions
Strictly follow these steps to complete the task:

1. **Detect Platform:** Determine whether the current system is Windows, Linux, macOS, or another Unix-like environment before choosing candidate paths.
2. **Find Candidate Directories:** Check only likely OpenCode data/session directories. Use environment variables instead of hardcoded usernames.
3. **Validate Scope:** Confirm that each candidate directory is an OpenCode data/session directory before scanning. Do not scan the entire home directory.
4. **Calculate Cutoff:** Use a default cutoff of 6 months before the current date. Use file modification time as the cross-platform default unless reliable OpenCode session metadata is explicitly available.
5. **Preview First:** List the candidate files or session folders older than 6 months, their total size, and the target base directory before deletion.
6. **Ask Confirmation:** Ask the user for explicit confirmation before deleting anything. The confirmation request must state the cutoff date, target directory, file count, and total size.
7. **Delete Safely:** After confirmation, delete only the previewed files or session folders that are still inside the confirmed OpenCode data/session directory.
8. **Report Results:** Summarize how many files or folders were deleted, how much space was freed, and whether any items failed to delete.

## 3. Candidate Paths
Check these paths when they exist:

### Windows
- `%LOCALAPPDATA%\\opencode`
- `%USERPROFILE%\\.local\\share\\opencode`
- `%APPDATA%\\opencode`

### Linux
- `$XDG_DATA_HOME/opencode`
- `~/.local/share/opencode`
- `$XDG_STATE_HOME/opencode`
- `~/.local/state/opencode`

### macOS / Unix-like Fallback
- `~/Library/Application Support/opencode`
- `~/.local/share/opencode`
- `~/.local/state/opencode`

## 4. Constraints & Rules
- **MUST DO:** Default to deleting sessions older than 6 months only after previewing them and receiving explicit user confirmation.
- **MUST DO:** Use modification time for age checks unless session metadata is clearly available and safer to use.
- **MUST DO:** Keep all path handling cross-platform and avoid hardcoded usernames.
- **MUST DO:** Verify that every deletion target is inside the confirmed OpenCode session/data directory.
- **MUST DO:** Prefer read-only inspection commands until the user confirms deletion.
- **DO NOT:** Delete anything from `~/.config/opencode`, `.opencode`, skill directories, agent directories, command directories, plugin directories, provider settings, or config files.
- **DO NOT:** Run broad deletion commands against a home directory, workspace root, or parent directory.
- **DO NOT:** Delete files based only on filename patterns without confirming they are under an OpenCode data/session directory.
- **DO NOT:** Archive session files unless the user explicitly asks for archive mode.
- **Output Language:** Provide explanations, summaries, warnings, and confirmation questions in Korean when the user uses Korean; otherwise use the user's language.

## 5. Suggested PowerShell Workflow
Use this style on Windows or PowerShell Core systems:

```powershell
$cutoff = (Get-Date).AddMonths(-6)
$candidates = @(
  (Join-Path $env:LOCALAPPDATA "opencode"),
  (Join-Path $env:USERPROFILE ".local/share/opencode"),
  (Join-Path $env:APPDATA "opencode")
) | Where-Object { $_ -and (Test-Path -LiteralPath $_) }

foreach ($dir in $candidates) {
  $oldItems = Get-ChildItem -LiteralPath $dir -Recurse -Force -File -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime -lt $cutoff }

  $totalBytes = ($oldItems | Measure-Object -Property Length -Sum).Sum
  [pscustomobject]@{
    Directory = $dir
    Cutoff = $cutoff
    Count = @($oldItems).Count
    MB = [math]::Round(($totalBytes ?? 0) / 1MB, 2)
  }
}
```

After user confirmation, delete only the exact previewed files and re-check paths before removal.

## 6. Suggested POSIX Shell Workflow
Use this style on Linux, macOS, or Unix-like systems:

```sh
cutoff_days=183
for dir in "${XDG_DATA_HOME:-$HOME/.local/share}/opencode" \
           "${XDG_STATE_HOME:-$HOME/.local/state}/opencode" \
           "$HOME/Library/Application Support/opencode"; do
  [ -d "$dir" ] || continue
  find "$dir" -type f -mtime +$cutoff_days -print
done
```

After user confirmation, delete only the exact previewed files and re-check paths before removal.

## 7. Safety Notes
- OpenCode sessions may contain prompts, assistant replies, tool output, file paths, code snippets, logs, and secrets if they appeared during a session.
- Deletion may bypass Recycle Bin or Trash depending on the command used.
- If the user is unsure, recommend a preview-only run or a backup before deletion.
