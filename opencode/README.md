# OpenCode

This directory is the global OpenCode configuration at `~/.config/opencode`.

## Install

Install the OpenCode CLI separately from this repository. The official installation instructions are at <https://opencode.ai/docs>.

Windows: OpenCode recommends WSL. Native alternatives include:

```powershell
scoop install opencode
```

Ubuntu or Omarchy: use the official installer or a supported package manager from the official documentation.

## Herd integration

Herd creates and manages `herdr-tui-session.js` and `plugins/herdr-agent-state.js`. They are intentionally ignored because installing or updating the Herd OpenCode integration regenerates them. Do not edit or restore these files from this repository.

`tui.jsonc` references the Herd TUI plugin. Install the Herd OpenCode integration before using that configuration on a new machine.

## Verify

After cloning and Herd integration setup, verify the configuration and skills:

```sh
opencode debug config
opencode debug skill
```

Quit and restart OpenCode after changing configuration, skills, or plugins because it loads them only at startup.
