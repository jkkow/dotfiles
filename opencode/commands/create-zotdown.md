---
description: Create a zotdown note about a selected subject from the current session.
model: openai/gpt-6.1-terra
---

Create a zotdown note from the current conversation using the `zotdown-note-creator` skill. Load the skill and follow its instructions for creating and verifying the note.

The user's optional subject is: $ARGUMENTS

If a subject was supplied, use it to select the relevant part of the current session and proceed. Otherwise, examine the current session and use the question tool to suggest several distinct, worthwhile subjects grounded in the conversation. Give each suggestion a short description and enable the tool's custom input so the user can enter a different subject. Wait for the user's selection or input before creating the note. If there is insufficient session context for meaningful suggestions, ask the user to specify a subject instead.

After the subject is chosen, create one note focused on that subject, using only relevant session content. Verify the note as instructed by the skill, then open the verified note in Obsidian using an `obsidian://open` URI with vault `jkko-notes` and the actual vault-relative note path, URL-encoding the parameter values. On Windows, launch the URI with PowerShell `Start-Process`; on other platforms, use the appropriate system URI opener. Report the resulting note path and whether the open request succeeded. If opening fails, keep the created note and report the failure.
