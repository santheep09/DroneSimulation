# Workflow: how we plan and run each phase

## Where each kind of work happens

| Work | Where | Why |
|---|---|---|
| Strategy, phase planning, reviews, re-planning, write-ups | **claude.ai** (the "Simulation Portfolio Creation" project) | Long-form thinking; the plan stays visible in every session |
| Writing code, Unity work, running Python/training, git | **Claude Code** on the Mac, opened in this `DroneSimulation` folder | Runs natively on macOS: Unity batchmode, PyTorch MPS, git, tests. Reads `CLAUDE.md` every session |

Rule of thumb: **decide in claude.ai, build in Claude Code.** The docs in `docs/` are where the two meet. Both read them, and Claude Code keeps the task files up to date.

## The phase loop (repeat for every phase)

```
 1. BRIEF ─► 2. BREAKDOWN ─► 3. BUILD (slices) ─► 4. VERIFY ─► 5. RETRO ─► next phase
 claude.ai   Claude Code      Claude Code          both         claude.ai
             (plan mode)
```

1. **Brief** (claude.ai). Copy `phases/_PHASE_TEMPLATE.md` to `phases/PhaseN_<Name>/BRIEF.md`. Fill in the goal, scope in/out, deliverables and **exit criteria**. Exit criteria must be checkable, e.g. "command X produces Y", not "data looks good".
2. **Breakdown** (Claude Code, plan mode). Prompt: *"Read docs/phases/PhaseN_x/BRIEF.md and CLAUDE.md. Propose a task breakdown into TASKS.md: small slices, each ≤ ~2 hours, each with its own done check."* Review it, edit it, approve it.
3. **Build** (Claude Code), one slice at a time:
   - Start each session with: *"Continue Phase N. Read TASKS.md, pick the next open task."*
   - Every task runs in either **Learning mode** (you write the code, Claude teaches, reviews and writes tests) or **Build mode** (Claude implements). See `CLAUDE.md`. Phase 2 is almost all Learning mode.
   - Use plan mode for anything touching more than 2–3 files.
   - Every slice ends in a **git commit** and a tick in `TASKS.md`.
   - Unity changes: Claude Code writes the C#; you check in the Editor. Headless steps run through `-batchmode -executeMethod` so Claude Code can run and check them itself.
4. **Verify** (both). Go through the exit criteria one by one, with evidence (command output, screenshots, numbers). Record the demo GIF or clip now, while it's fresh.
5. **Retro** (claude.ai). Fill in `RETRO.md`: what worked, what slipped, decisions changed. Update `00_MASTER_PLAN.md` and `DECISIONS.md`, then write the next phase's brief.

## Per-phase folder layout

```
docs/phases/Phase1_Foundation/
  BRIEF.md     ← goal, scope, exit criteria (written in claude.ai)
  TASKS.md     ← task breakdown and checkboxes (kept by Claude Code)
  NOTES.md     ← findings, gotchas, links (kept by Claude Code)
  RETRO.md     ← end-of-phase review
  START_PROMPT.md ← what to paste into Claude Code for the phase's first session
  media/       ← screenshots, GIFs for the README and video
```

## Skills and tooling

- **No special skill is needed to start.** Phase 1 runs on Claude Code's built-in tools: plan mode, file editing, shell, git, plus the Unity MCP server.
- Phase 1 creates three project slash commands: `/phase-status`, `/log`, `/phase-verify`. Add more only once something repeats 3 or more times (e.g. `/dataset-check` in Phase 4, `/seed-sweep` in Phase 5).
- Subagents: useful from Phase 2 on for independent reviews ("review this capture code for frame/label sync bugs").

## Session hygiene

- One phase task per Claude Code session where possible; run `/clear` between unrelated tasks.
- Generated data and training runs are never committed. They're git-ignored and can always be regenerated from a seed.
- On a capped plan, usage limits are the constraint: keep sessions focused and plan in claude.ai rather than in long Claude Code chats.
- When a decision changes, add an entry to `DECISIONS.md` before changing code.
