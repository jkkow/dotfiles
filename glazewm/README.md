# GlazeWM

GlazeWM is Windows-only. Its configuration starts YASB when it is installed;
see [`yasb/README.md`](../yasb/README.md) for YASB setup.

## Windows

### Install

```powershell
winget install --id glzr-io.glazewm -e --scope user
```

### Configure

Set the GlazeWM configuration path once:

```powershell
$configPath = Join-Path $HOME ".config\glazewm\config.yaml"
if (-not (Test-Path -LiteralPath $configPath -PathType Leaf)) {
    throw "GlazeWM config was not found: $configPath"
}
[Environment]::SetEnvironmentVariable("GLAZEWM_CONFIG_PATH", $configPath, "User")
$env:GLAZEWM_CONFIG_PATH = $configPath
```

Start GlazeWM manually when needed:

```powershell
glazewm start
```

Press `Alt+Shift+R` to reload GlazeWM's `config.yaml`. It does not rerun
`startup_commands`; start YASB separately or restart GlazeWM to apply its
lifecycle integration. This guide does not configure automatic startup.

## Tiling And Exceptions

New managed windows tile by default. `window_rules` in `config.yaml` defines
the exceptions:

- Use `ignore` for windows that GlazeWM must not manage, such as YASB and
  picture-in-picture overlays.
- Use `set-floating` for managed dialog or utility windows that should remain
  movable and resizable. The configuration already floats standard Windows
  dialogs and file pickers (`window_class: "#32770"`), Fusion 360's Parameters
  window, and Bitwarden extension popups.
- Add an exception only after identifying a stable `window_process`,
  `window_class`, or `window_title` match. Prefer an exact process or class
  match over a broad title regular expression.

Example: keep a utility from `example.exe` floating.

```yaml
- commands: ["set-floating"]
  match:
    - window_process: { equals: "example" }
```

Place the rule under the `FLOATING EXCEPTIONS` section, then press
`Alt+Shift+R` to reload the configuration. To temporarily float or retile the
focused window without adding a rule, use `Alt+Shift+Space` or `Alt+T`.
