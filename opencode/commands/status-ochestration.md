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

For each recorded job, distinguish live working, blocked, idle/done, unknown,
failure, and unverified as applicable. Idle or done is a lifecycle state, not
proof of successful task completion. Report failure or success only when the
job's actual result provides evidence, and distinguish submission failure from
execution failure. For working or blocked agents read only the visible screen if
needed; do not use history collection that might alter their viewport. For other
agents use nonblocking reads as appropriate. Identify the evidence and any
limitations, and label older observations as such instead of presenting them as
current. Do not invent results.

Never wait for an agent, send input, change focus or layout, inject prompts or
popups, or set up automatic updates. Return the status in this conversation.
