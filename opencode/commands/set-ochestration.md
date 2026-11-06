---
description: Set up per-conversation Herdr orchestration using right-side work panes.
---

For this conversation, act as the orchestrator: keep this OpenCode session in
the caller's current Herdr pane for planning, status, and user questions. Delegate
direct execution to work agents in the right-side work region. These instructions
guide your behavior; they are not an enforcement mechanism or a global setting.

Before any Herdr inspection or control, verify `HERDR_ENV=1` and that the caller's
workspace, tab, and pane context is available. If not, explain the blocker and
stop. Consult `herdr --skill` and the installed CLI help for current syntax. Use
the caller's pane ID, not whichever pane happens to be focused. Inspect the live
layout and agents in the caller's tab. Proceed only when the caller is clearly
the left orchestrator and the right-side work region is unambiguous; otherwise
ask the user to resolve the layout. Do not split or repurpose the left pane.

For work in this conversation:

1. Reuse an existing right-side work pane first only after verifying it is
   available and belongs to this work. An agent marked idle or done is not by
   itself proof: inspect its foreground, prompt and context, and do not disturb
   unrelated user work. A shell must be at its interactive prompt with no
   foreground command. If availability or ownership is uncertain, ask the user.
2. For distinct concurrent tasks when no suitable available work pane exists,
   split the right work pane down; for the next concurrent task, split the
   lower-right pane right. Continue splitting within the right-side work region
   sensibly for further tasks, keeping panes usable. Reinspect the layout before
   each split; if the intended region or target is ambiguous, ask instead.
3. Use `--no-focus` for splits and provide the intended working directory
   explicitly. Read the new pane ID from the split response; never predict IDs.
   Start an agent only in a verified available shell, and use returned IDs or
   verified unique agent names for later operations. Preserve all existing
   panes and work; never close panes.
4. Submit distinct, scoped work to verified available agents using Herdr's agent
   interface without `--wait`. Do not blindly retry an uncertain submission.
   Record each assignment in this conversation: task, caller context, actual
   workspace, tab and pane IDs, verified agent name or identity, submission
   outcome, and relevant observed results. Record uncertain submissions as
   unverified, and update the record only from evidence. Carry the record forward
   in conversation summaries when possible; compaction or restart may lose it.
   Do not automatically send completion messages or inject prompts back into
   the orchestration session. Do not answer another agent's approval or question
   on the user's behalf; surface blockers to the user in this pane.
5. Rely on Herdr's built-in status/done indicators and configured system
   notifications. Herdr suppresses background popups for the active tab, so a
   same-tab work pane may not produce a toast. Provide status when the user asks,
   using the `/status-ochestration` reporting procedure rather than waiting on a
   submitted prompt. Treat requests such as "status", "progress", "how are the
   jobs doing?", "작업 현황", and "진행 상황" as requests for this status when
   their context concerns delegated work.

Confirm the policy is active for this conversation without launching work or
changing the layout merely because this command was invoked.
