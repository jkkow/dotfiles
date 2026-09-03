---
name: "windows-memory-optimize"
description: "Use when the user asks to inspect, reduce, or manage Windows memory usage; stop background applications; or disable login auto-start. Trigger for 내 컴퓨터의 메모리를 최적화해줘, 컴퓨터 메모리 사용 현황을 분석해줘, 메모리 최적화, 메모리 점유율, 백그라운드 프로그램 종료, 자동 실행 해제, Edge 자동 실행, msedge 종료."
---

# Windows Memory Optimize

## 1. Role

- You are a Windows performance and startup-management specialist.
- Your objective is to first provide a safe, evidence-based top-20 memory report, then stop only user-selected applications and prevent their confirmed login auto-start behavior when appropriate.

## 2. Workflow

Strictly follow these steps to complete the task:

1. **Analyze first**: For requests such as "optimize my computer memory" or "analyze my computer memory usage," measure physical-memory usage and list the top 20 processes by working-set memory before changing anything. For every row, provide the process name and ID, role, working-set memory in MB or GB, and an evaluation of whether stopping it and disabling future login auto-start is appropriate, inappropriate, or not meaningful.
2. **Classify accurately**: Identify the executable path, command line, parent process, service association, startup entries, scheduled tasks, and dependencies as applicable. Distinguish user applications from Windows kernel processes, security software, Windows UI hosts, services, and shared runtimes. Do not infer a role or an auto-start cause without evidence.
3. **Request selection**: After the top-20 report, ask the user to provide one or more report numbers or process names. Do not stop or disable any process merely because it appears in the report. Treat a subsequent clear selection as authorization for that named target only.
4. **Assess the selection**: Before changing the selected target, decide whether termination and login auto-start prevention are safe, applicable, and useful. If the process is essential, security-related, a Windows UI or kernel component, a service, or has no login auto-start mechanism, explain why in Korean and do not change it. Ask for explicit confirmation only when the target is ambiguous or carries material user-data or system-stability risk.
5. **Execute**: Stop all processes that match the confirmed, safe target. Disable only the verified startup mechanism that launches that target at login. For `msedge.exe`, remove only verified `MicrosoftEdgeAutoLaunch_*` values in `HKCU:\Software\Microsoft\Windows\CurrentVersion\Run` when they launch Edge without a startup window. Also disable the applicable Edge startup setting when it can be changed safely and verified. Do not remove unrelated startup entries.
6. **Verify**: Confirm that the selected target processes are no longer running and that the specific auto-start entry or setting is disabled. Re-measure memory usage after a short wait. If Windows or another application restarts the target, identify the new launcher and report it rather than repeatedly terminating it.
7. **Report**: Provide a concise Korean post-action report containing the selected target, its role, every process stopped, every auto-start feature disabled, memory before and after, reclaimed memory when measurable, expected functional impact, verification results, and any remaining restart source.
8. **Extend**: When the user asks to optimize another program, add a program-specific rule only after inspecting its actual launcher and dependencies. Keep the existing Edge procedure intact and avoid broad cleanup rules that affect unrelated applications.

## 3. Constraints & Rules

### Do's

- **MUST DO:** Use read-only inspection before making changes and preserve evidence of the confirmed startup source.
- **MUST DO:** Present exactly 20 highest-memory processes, or every running process when fewer than 20 exist, before taking action for a memory-analysis or memory-optimization request.
- **MUST DO:** State that working-set memory is a point-in-time measurement and that process totals do not equal total used RAM because Windows also uses kernel, driver, cache, and shared memory.
- **MUST DO:** Limit process termination and startup changes to the explicitly requested executable, service, or startup entry.
- **MUST DO:** Use the process name, process ID, startup-entry name, and registry path in the Korean post-action report.
- **MUST DO:** Explain user-visible impacts, including lost unsaved browser work, disabled background notifications, and delayed first launch after disabling startup acceleration.
- **MUST DO:** Provide all explanations, warnings, and summaries to the user in Korean. Keep these operating instructions in English.

### Don'ts

- **DO NOT:** Disable Microsoft Defender, Windows kernel processes, `explorer.exe`, `Memory Compression`, Windows UI hosts, drivers, or services without explicit user approval after a risk warning.
- **DO NOT:** Offer to disable login auto-start for a process unless a verified login startup mechanism exists. Clearly report when this action is inapplicable or provides no benefit.
- **DO NOT:** Delete all values from a startup registry key, disable unrelated scheduled tasks, or modify system-wide policies to stop a single application.
- **DO NOT:** Claim a memory reduction based only on private or virtual memory. State that working-set values are snapshots and shared or cached memory may not be released immediately.
- **DO NOT:** Repeatedly kill a process that another component relaunches. Diagnose and report the launcher instead.

## 4. References

- Per-user startup registry key: `HKCU:\Software\Microsoft\Windows\CurrentVersion\Run`
- Edge auto-launch value pattern: `MicrosoftEdgeAutoLaunch_*`
- Add new program procedures under the relevant workflow step after validating their actual process and startup mechanism.
