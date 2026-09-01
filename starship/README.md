# Starship

Starship is configured by `starship/starship.toml` and is used by the Bash and PowerShell configurations in this repository.

## Install

Windows:

```powershell
winget install --id Starship.Starship --exact --scope machine
```

Ubuntu or Omarchy: install `starship` with the distribution package manager.

## Configure

The Bash configuration uses the standard XDG path. The PowerShell initializer sets `STARSHIP_CONFIG` to `$HOME\.config\starship\starship.toml`; complete `powershell/README.md` before opening a new PowerShell session.
