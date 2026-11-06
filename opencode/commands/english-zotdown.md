---
description: Create an English-learning zotdown note from the current session.
model: openai/gpt-6.1-terra
---

Create one English-learning zotdown note from the selected source conversation. Load the
`zotdown-note-creator` skill and follow its instructions for storage, naming,
frontmatter, Korean explanatory text, formatting, and verification. For this
command only, override the skill's empty `pid` with the single YAML scalar
`pid: jkko.resource.english`; retain the other frontmatter fields and their order.
Never overwrite an existing note.

The user's optional topic or range is: $ARGUMENTS

If no transferred source is supplied, use the optional topic or range to select
the relevant portion of the current session, or cover its accessible portion if
none is specified. Disclose incomplete context or an unavailable requested range.

For a separate work session, the caller may supply a `SOURCE PAIRS` block in
slash arguments or separately provided source material. The block identifies the
source session or a non-sensitive descriptive label, the requested scope, and
coverage limitations; it contains numbered pairs, each with a verbatim `ORIGINAL`
user question and its verbatim actual adjacent assistant `REFINED QUESTION`.
Mark a missing side or uncertain adjacency explicitly rather than filling it in.
For example, using delimiters on their own lines:

```text
SOURCE PAIRS BEGIN
Source: <session label>
Scope: <selected topic or range>
Limitations: <selection, missing context, or uncertainty>
PAIR 1
ORIGINAL BEGIN
<exact original user question>
ORIGINAL END
REFINED QUESTION BEGIN
<exact adjacent refined question>
REFINED QUESTION END
SOURCE PAIRS END
```

Treat an explicitly supplied block as selected source material, not as the work
session's own conversation. Do not include worker conversation, delegation or
unrelated orchestration prompts as source examples unless explicitly identified
as part of the requested source. Use only supplied source material and accessible
current-session context as applicable; do not search arbitrary other session history.
Do not infer full coverage from a selection or verify adjacency beyond the evidence
provided. Identify the source as supplied and disclose scope, selection and any
known or unverified limitations near the examples or in the final report. If a
separate source was requested but not supplied, ask for it or report it unavailable;
never silently substitute the worker session or invent source text.

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
