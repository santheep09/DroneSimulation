# Phase 1: Foundation ("make the base right")

**Status:** Not started · **Guide:** about 1 week · **Mode:** mostly Build; Learning mode for the Claude Code workflow itself

## Goal
A **working agent workflow** before any simulation code exists: Claude Code set up and following `CLAUDE.md`, the repo structured and on GitHub, a Unity 6 project that runs tests headless, a Python env with PyTorch on MPS, Unity MCP connected read-only, and the whole phase loop (plan → build → test → commit → log) rehearsed once on a tiny real task.

Every later phase depends on this loop. If it's shaky, Phase 3+ will be slow and messy.

## Why it matters
- For you: learning a proper Claude Code workflow is one of your stated goals.
- For reviewers: a clean repo, reproducible setup, headless tests and a decision log signal senior engineering.

## Scope
**In**
- Claude Code installed, opened in this folder, reading `CLAUDE.md`
- Read-only environment check
- Repo structure, git + GitHub + LFS, `.gitignore`, `.gitattributes`
- Unity 6 project in `/sim` (you create it via Unity Hub; Claude Code gives exact steps), with headless EditMode tests running from the CLI
- Python env in `/ml` (uv), PyTorch MPS check; ML-Agents version pinned (D-005)
- Official Unity MCP server connected **read-only**
- 2–3 project slash commands for the workflow
- One rehearsal slice through the full loop

**Out**
- Any dynamics, control, ML or RL code. That's Phase 2 (you write it) and Phase 3.
- ML-Agents package install in Unity (Phase 2b, 3DBall)

## Target structure
```
DroneSimulation/
  CLAUDE.md  README.md  .gitignore  .gitattributes
  .claude/commands/        ← project slash commands
  sim/                     ← Unity 6 project (Assets/, Packages/, ProjectSettings/)
  ml/                      ← Python 3.12 + current PyTorch: pyproject.toml, src/, tests/
  rl/                      ← Python 3.10.12 + torch 2.2 + mlagents (ML-Agents requires it, D-011)
  learning/                ← Phase 2 hand-written exercises (2a-ml/, 2b-rl/, 2c-drones/)
  infra/                   ← setup_check.sh, CLI wrappers (unity_test.sh, …)
  docs/
    00_MASTER_PLAN.md  PROBLEM_STATEMENT.md  DECISIONS.md  WORKFLOW.md  LEARNING_LOG.md
    phases/Phase1_Foundation/  BRIEF.md  TASKS.md  NOTES.md  RETRO.md  START_PROMPT.md
```

## Exit criteria (all must pass)
- [ ] Claude Code summarises the two working modes from `CLAUDE.md` correctly (≤ 5 lines)
- [ ] `infra/setup_check.sh` prints: git, git-lfs, Python version, uv, Unity 6 editor path/version, and `MPS available: True`
- [ ] Repo on GitHub; `sim/Library`, `Temp`, `Logs`, `UserSettings`, `Builds`, `.venv`, data and runs are **not** tracked (`git status` clean after opening Unity)
- [ ] Unity project: Force Text serialisation, Visible Meta Files, URP, Rider as external editor
- [ ] `infra/unity_test.sh` runs Unity EditMode tests **headless** (`-batchmode -runTests`) and exits 0; results XML saved
- [ ] `ml/`: `uv run python -c "import torch; print(torch.backends.mps.is_available())"` → True; `uv run pytest` green (one smoke test)
- [ ] ML-Agents version chosen and pinned; `rl/` env runs `uv run mlagents-learn --help` (D-005/D-011 updated)
- [ ] Unity MCP connected read-only: Claude Code can list the open scene hierarchy and read the Console
- [ ] Claude Code config in place (TASKS 1.9): permissions, hooks (the learning guard blocks a test write under `learning/`), 3 rules, skills `/phase-status` `/log` `/phase-verify`, agents `test-runner` `code-reviewer` `phase-verifier`, status line
- [ ] Rehearsal slice done through the full loop (see TASKS 1.8) with a commit and a TASKS tick
- [ ] `RETRO.md` written; Phase 2 brief drafted (in claude.ai)

## Risks
| Risk | Mitigation |
|---|---|
| Unity batchmode test runner quirks on macOS (licence activation, Metal) | Do task 1.5 early; record gotchas in NOTES.md |
| Unity MCP setup changes between versions | Claude Code looks up the current official docs at setup time; read-only first |
| Python/ML-Agents version mismatch | Pin the Python version to what the chosen `mlagents` release supports before installing anything else |
| Claude usage limits during setup | Keep sessions focused: one task, `/clear` between tasks |
| Over-polishing the setup | Exit criteria are the finish line; anything beyond goes in NOTES.md as "later" |

## Demo at the end
Terminal recording: `infra/setup_check.sh` → `infra/unity_test.sh` → `uv run pytest`, all green.
