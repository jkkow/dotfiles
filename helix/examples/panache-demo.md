# Panache Markdown demo

From the dotfiles repository root (`~/.config`), run:

```text
hx helix/examples/panache-demo.md
panache lint helix/examples/panache-demo.md
```

In Helix, use `Space d` to see LSP diagnostics. Place the cursor on `one` in
the valid footnote below and press `gd` to jump to its definition. The missing
footnote and reference label are intentional. The CLI lint command is separate
from the LSP; it also reports these undefined labels with Panache 3.17.2.

Valid footnote[^one] and [valid link][guide].

Missing footnote[^missing] and [missing link][unknown].

[^one]: This is the valid footnote definition.

[guide]: https://example.com/

### Intentionally skipped heading level

The jump from heading level 1 to level 3 is a `heading-hierarchy` lint example.
