# OpenCode

Global OpenCode configuration at `~/.config/opencode`.

## Install

Install OpenCode using the current instructions at <https://opencode.ai/docs>.
On Windows, WSL is the supported route. Native Scoop users can run:

```powershell
scoop install opencode
```

## Verify

After installation, run:

```sh
opencode debug config
opencode debug skill
```

`tui.jsonc` requires the Herd integration. Its generated files,
`herdr-tui-session.js` and `plugins/herdr-agent-state.js`, are intentionally
ignored; install or update Herd through its own documentation. Quit and restart
OpenCode after changing configuration, skills, or plugins.
