---
description: Create an English-learning zotdown note from the current session.
model: openai/gpt-6.1-terra
---

Create one English-learning zotdown note from the current conversation. Load the
`zotdown-note-creator` skill and follow its instructions for storage, naming,
frontmatter, Korean explanatory text, formatting, and verification. For this
command only, override the skill's empty `pid` with the single YAML scalar
`pid: jkko.resource.english`; retain the other frontmatter fields and their order.
Never overwrite an existing note.

The user's optional topic or range is: $ARGUMENTS

If supplied, use it to select the relevant portion of the session. Otherwise,
cover the accessible current session. Disclose when session context is incomplete
or a requested range is unavailable; do not invent missing source text.

Identify original user messages and their actual adjacent assistant `Refined
question` responses within that scope. Match each message only to its own response,
and quote both faithfully. If either side is missing or cannot be matched reliably,
say so rather than reconstructing it or pairing it with another response. Select
educational patterns from the available pairs rather than treating every change as
an error. Distinguish Korean-to-English expression from correction of original
English, and distinguish grammatical errors from optional stylistic improvements.
Flag any changes in meaning, omissions, or added assumptions in a refinement.

Structure the note body in exactly this H2 order:

1. `## Example Sentences`: For each selected example, quote the original Korean or
   English user question and its actual adjacent `Refined question` faithfully,
   keeping the pair together. Identify its intent, then immediately provide concise
   Korean learning points on expressions and possible improvements. Distinguish
   English errors from optional style choices; Korean-to-English translation is
   expression practice, not an error in the Korean. Flag actual meaning shifts,
   omissions, and added assumptions; never call a meaning-changing refinement
   correct without qualification.
2. `## Key Expressions`: Summarize reusable phrases from the selected examples
   with concise Korean explanations.
3. `## Practice`: Provide newly composed, clearly labeled active recall exercises
   grounded in the selected material, with clearly labeled example answers in
   collapsible `<details>` blocks. Do not present exercises or answers as source
   quotations.

Do not add a scope-and-sources section. Briefly report inaccessible pairs or partial
context near the relevant entry or in the final user report. If material is
insufficient, explain the limitation rather than fabricating examples or pairs.
Generalize explanatory prose to normal situations; preserve source quotations
exactly, including any environment names they contain.

Verify the saved note using the skill's checks, including that its `pid` is exactly
the single scalar `jkko.resource.english`. Only after verification, open it in
Obsidian using an `obsidian://open` URI with vault `jkko-notes` and the actual
vault-relative note path, URL-encoding the parameter values. On Windows, launch
the URI with PowerShell `Start-Process`; on other platforms, use the appropriate
system URI opener. Report the note path and whether the open request succeeded.
If opening fails, keep the verified note and report the failure.
