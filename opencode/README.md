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
