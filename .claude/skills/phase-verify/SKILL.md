---
name: phase-verify
description: Check every exit criterion in the current phase BRIEF.md with evidence. Use before closing a phase or when asked whether the phase is done.
context: fork
allowed-tools: Read, Grep, Glob, Bash
---
# Phase verify

You run in a forked context with no chat history. Verify, do not fix.

1. Find the current phase folder under `docs/phases/` (the one whose `TASKS.md` has open items, else the latest). Read its `BRIEF.md` and extract the "Exit criteria" checklist.
2. For each criterion, gather concrete evidence by running the relevant command or reading the relevant file (for example `infra/unity_test.sh`, `cd ml && uv run pytest`, `git ls-files`, file existence, `git log`). Run only read-only or test commands; never modify files or commit.
3. Report a table: criterion | PASS / FAIL / UNVERIFIED | evidence (command run and key output, or file path). Mark UNVERIFIED if it needs the Editor or a human check, and say exactly what to click or look at.
4. End with one line: ready to close the phase, or the list of failing and unverified items.

Be skeptical: a ticked box in TASKS.md is not evidence.
