---
description: Create a zotdown note about a selected subject from the current session.
model: openai/gpt-6.1-terra
---

Create a zotdown note from the current conversation using the `zotdown-note-creator` skill. Load the skill and follow its instructions for creating and verifying the note.

The user's optional subject is: $ARGUMENTS

If a subject was supplied, use it to select the relevant part of the current session and proceed. Otherwise, examine the current session and use the question tool to suggest several distinct, worthwhile subjects grounded in the conversation. Give each suggestion a short description and enable the tool's custom input so the user can enter a different subject. Wait for the user's selection or input before creating the note. If there is insufficient session context for meaningful suggestions, ask the user to specify a subject instead.

After the subject is chosen, create one note focused on that subject, using only relevant session content. Report the resulting note path.
