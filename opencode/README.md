# OpenCode

Global OpenCode configuration at `~/.config/opencode`.

## Windows

### Install

```powershell
winget install --id SST.opencode --exact --scope user
```

### Configure

No additional configuration is required after cloning this repository.

## Ubuntu

### Install

```sh
curl -fsSL https://opencode.ai/install | bash
```

### Configure

No additional configuration is required after cloning this repository.

## Omarchy

### Install

```sh
curl -fsSL https://opencode.ai/install | bash
```

### Configure

No additional configuration is required after cloning this repository.

## Verify

```sh
opencode debug config
opencode debug skill
```

`tui.jsonc` requires the Herd integration. Its generated files are intentionally
ignored. Quit and restart OpenCode after changing configuration, skills, or
plugins.
