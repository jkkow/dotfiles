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

## Herdr orchestration commands

Run `/set-ochestration` in the left-hand OpenCode pane of an unambiguous Herdr
layout to establish the per-conversation orchestration policy. The main pane
remains for planning, status, and questions; execution uses verified available
right-side work panes, splitting down and then right for concurrent work. The
command preserves unrelated work, keeps focus in place, and asks when the layout
or pane availability is unclear. It does not launch work on invocation.

This command is a prompt guiding the current conversation, not an enforcement
mechanism or global Herdr setting. It uses Herdr's built-in status and done
indicators and configured system notifications; Herdr suppresses popups for the
active tab, so same-tab completions may not generate a toast. Ask the orchestrator
for status when needed. No automatic message is injected into its session.

Use `/status-ochestration` to report only jobs recorded for the current
orchestration conversation. After `/set-ochestration`, contextual requests such
as "status", "progress", "작업 현황", or "진행 상황" also request that report.
The report checks live Herdr state without waiting or changing focus; idle or
done alone does not establish success. Assignment records live in conversation
context and may be lost after compaction or restart. If records are unavailable,
provide the missing details rather than assuming every right-side pane is a job.
Both commands are instructions to the assistant, not hard enforcement.

## FreeCAD MCP

The configured `freecad` MCP server connects OpenCode to a local FreeCAD
instance through the FreeCAD MCP add-on. It requires FreeCAD, `uv`, and a clone
of [freecad-mcp](https://github.com/neka-nat/freecad-mcp) at
`~/.local/opt/mcp/freecad-mcp`.

### Set up FreeCAD

1. Create `~/.local/opt/mcp`, clone the server as
   `~/.local/opt/mcp/freecad-mcp`, and install its locked dependencies with
   `uv sync` in the clone.
2. Install `addon/FreeCADMCP` from the clone in FreeCAD's add-on directory,
   then restart FreeCAD.
3. In FreeCAD, select the **MCP Addon** workbench and start **RPC Server** from
   the **FreeCAD MCP** toolbar. To start it on subsequent FreeCAD launches,
   enable **FreeCAD MCP** > **Auto-Start Server**.

### Configure OpenCode

Configure the local server in `opencode.jsonc`:

```jsonc
{
  "mcp": {
    "freecad": {
      "type": "local",
      "command": [
        "uv",
        "--directory",
        "<freecad-mcp-directory>",
        "run",
        "freecad-mcp"
      ]
    }
  }
}
```

Replace `<freecad-mcp-directory>` with the clone's absolute path. `command`
must remain an array of executable and argument strings. Quit and restart
OpenCode after changing its configuration.

## Verify

```sh
opencode debug config
opencode debug skill
```

`tui.jsonc` requires the Herd integration. Its generated files are intentionally
ignored. Quit and restart OpenCode after changing configuration, skills, or
plugins. The FreeCAD RPC server must be running before using FreeCAD MCP tools.
