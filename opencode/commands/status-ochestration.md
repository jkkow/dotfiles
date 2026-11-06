---
description: Report the current conversation's delegated Herdr job status.
---

Report status only for jobs actually recorded as delegated by this orchestration
conversation. This is a prompt guiding behavior, not an enforcement mechanism.
Do not infer assignments from pane position, name, or activity. Consult the
conversation's assignment record for the task, caller context, actual workspace,
tab and pane IDs, agent identity, submission outcome, and observed results.
If the record is missing or incomplete, say what is unknown and ask the user for
the missing context; do not assume that no jobs exist. Compaction or an OpenCode
restart may lose conversation context; recover only from available evidence or
user-provided context, never by guessing.

Before any Herdr inspection, verify `HERDR_ENV=1` and the caller's workspace,
tab and pane context. If unavailable, report the blocker and any records as
unverified; stop. Consult `herdr --skill` and installed CLI help as needed. Use
nonblocking, read-only live status and explicit recorded IDs or verified agent
names, scoped to the current Herdr session. Check that the live pane and agent
still match the record; if missing, moved, replaced, ambiguous, or unreachable,
report unverified rather than assigning its state to the job.
Read the current layout without changing it, after the context checks above, to
determine each verified recorded pane's relative location. If the layout or pane
position is unavailable or ambiguous, report the location as unknown. Never use
layout to infer an assignment or identity.

For each recorded job, distinguish live working, blocked, idle/done, unknown,
failure, and unverified as applicable. Idle or done is a lifecycle state, not
proof of successful task completion. Report failure or success only when the
job's actual result provides evidence, and distinguish submission failure from
execution failure. For working or blocked agents read only the visible screen if
needed; do not use history collection that might alter their viewport. For other
agents use nonblocking reads as appropriate. Identify the evidence and any
limitations, and label older observations as such instead of presenting them as
current. Do not invent results.

Report concisely in the user's language, using this structure:

1. State the current overall goal and plan only as grounded in the conversation;
   if unknown or incomplete, say so rather than guessing.
2. Give a task table with purpose, task status, responsible role-based descriptive
   alias, current relative pane location, and a concise observed result. Use
   completed, in progress, blocked, waiting, or unverified only as supported by
   evidence; identify live agent lifecycle separately from task status. Label old
   evidence as old, and distinguish submission failure from execution failure.
   List only recorded delegated jobs as delegated; identify any evidenced planned
   but not-yet-delegated steps separately, never as active jobs.
3. State the next planned step or dependency only when evidenced, followed by
   relevant limitations or missing context. Ask for missing context as above.

Reporting aliases are conversation-only labels, not actual pane or agent names.
Use a recorded task-specific alias when available; otherwise derive a descriptive
role-based alias only from a verified assignment and label it as a reporting alias.
Include recorded stable workspace, tab and pane IDs and verified agent names in
compact details where needed to identify the evidence. Never rename panes or
agents to match an alias.

Never wait for an agent, send input, change focus or layout, inject prompts or
popups, or set up automatic updates. Return the status in this conversation.
