---
name: phase-status
description: Summarise the current phase, what is done, what is next and any blockers. Use when the user asks where things stand or at session start.
allowed-tools: Read, Grep, Glob, Bash(git status:*), Bash(git log:*)
---
# Phase status

1. Find the current phase: the folder under `docs/phases/` that has a `TASKS.md` with open `- [ ]` items (ignore `_PHASE_TEMPLATE.md`).
2. Read that phase's `BRIEF.md` (goal, exit criteria) and `TASKS.md`; skim `NOTES.md` for open gotchas.
3. Run `git status -sb` and `git log --oneline -8`.
4. Reply in under 20 lines:
   - **Phase** and goal (one line)
   - **Done**: ticked tasks, with commit hashes
   - **Next**: the first open task and its sub-steps
   - **Blockers / risks**: anything in NOTES.md or uncommitted work that stands in the way
   - **Exit criteria**: count met / total (do not verify them here; `/phase-verify` does that)

Do not edit any file.
