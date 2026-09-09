# YASB

YASB is a Windows status bar. This directory is YASB's native configuration
location because this repository is cloned to `~/.config`.

## Windows

### Install

```powershell
winget install --id AmN.yasb -e
```

### Configure

No copy or environment-variable setup is required. YASB loads `config.yaml`
and `styles.css` from this directory by default.

The tracked bar uses GlazeWM workspace, tiling-direction, and binding-mode
widgets. It expects GlazeWM's default IPC server at `ws://localhost:6123`.
GlazeWM reserves the bar's 48px footprint with `gaps.outer_gap.top`.

The bar uses a stable full-width layout.

### Run

```powershell
yasb
```

YASB automatically reloads when `config.yaml` or `styles.css` changes. Use
`yasbc log` to view its logs.
