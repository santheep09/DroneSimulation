# CLAUDE.md: Search-and-Rescue Rover Simulator

## Project
Unity 6 ground-vehicle simulator (plan v4, D-019). A 4-wheel skid-steer rover searches procedurally generated biomes (dunes, rocky wadis, urban blocks, mangroves) for people and vehicles. ROS 2 is the external interface (D-021). One sim core feeds: (1) a validation pipeline (scenarios scored on success/safety/cost, ROS 2 SIL and VLM agents, CI), (2) a synthetic dataset + object detector, (3) an RL search policy (ML-Agents 4.x). Optional later: lunar biome, cross-sim comparison, drone. Names per D-023 (repo RoverSimulation, Unity folder and namespace RoverSim). Portfolio project.

## About me
Personal context lives in `CLAUDE.local.md` (gitignored, loaded automatically). **Never copy personal details (background, employer, location, hardware, career plans, subscription) into any tracked file or commit message.** A hook enforces this.

## Read first
`docs/00_MASTER_PLAN.md` → `docs/DECISIONS.md` → `docs/WORKFLOW.md` → the current phase's `BRIEF.md` and `TASKS.md` under `docs/phases/`.

## Working mode
This repo holds the project only. Claude implements directly (Build mode): Unity/C# engine work, Python tooling, infrastructure, CI, data plumbing, docs. Explain non-obvious choices briefly. Personal learning material is kept outside this repo (D-022).

## Working rules
- One TASKS.md task at a time; say which one at session start.
- **Plan mode** before changes touching more than 3 files, any new system, or anything in a new phase.
- After each task: run the checks → small commit with a clear message → tick TASKS.md with the hash → gotchas to NOTES.md.
- Never commit `RoverSim/Library`, `Temp`, `Logs`, `UserSettings`, `Builds`, `.venv`, datasets, training runs.
- Everything that generates data or runs simulation takes a **seed** and is deterministic.
- Prefer headless CLI steps (`-batchmode`, `-runTests`, `-executeMethod`) so results can be checked without the Editor. When the Editor is required, tell me exactly what to click or check.
- Unity MCP is **read-only** until DECISIONS.md says otherwise.
- Don't contradict DECISIONS.md; propose a new D-xxx entry first.
- Look up current docs for fast-moving tools (Unity MCP, ML-Agents, uv) instead of relying on memory.

## Fixed technical decisions (see DECISIONS.md)
- Dynamics in **SI units**, world **ENU**, body **FLU** (ROS REP 103, D-020); convert to Unity at **one boundary class** only.
- **500 Hz** fixed physics step (`Time.fixedDeltaTime = 0.002`); cascaded control (rover: 500 Hz wheel-speed inner loop, 50 Hz velocity/heading/path outer loop). Custom integrator, no Rigidbody forces (D-016); same-machine bitwise replay (D-017).
- Custom label capture (no Unity Perception): segmentation, 2D boxes, COCO export.

## Layout
`RoverSim/` Unity 6.6 project, pinned to 6000.6.2f1 (D-013: never upgrade mid-phase) (C# namespace `RoverSim.*`) · `ml/` Python 3.12 + current PyTorch (uv) · `rl/` Python 3.10.12 + torch 2.2 + mlagents (uv; ML-Agents requires it) · `infra/` scripts · `docs/` plan, decisions, phases, specs.

## Conventions
Path-scoped rules in `.claude/rules/` (`unity-csharp.md`, `python.md`) load when matching files are touched.

## Commands (fill in as they're created)
- Setup check: `infra/setup_check.sh`
- Unity tests (headless): `infra/unity_test.sh`
- Python tests: `cd ml && uv run pytest`
- Slash commands: `/phase-status`, `/phase-verify`

## Agent skills

Only `mattpocock-skills` and the project's own skills are enabled (`.claude/settings.json` turns the other plugins off). **Code review: always use `/code-review` from mattpocock-skills** (Standards + Spec axes). Its Standards axis reads `CODING_STANDARDS.md`. The built-in and plugin `code-review` skills are off. `.claude/agents/code-reviewer.md` is only a quick read-only pre-commit pass, not the main review.

New decisions go in `docs/DECISIONS.md` as the next D-xxx, even when `/grill-with-docs` would suggest an ADR. `docs/adr/` stays unused so there is one decision log.

### Issue tracker

GitHub Issues on santheep09/RoverSimulation, via the `gh` CLI. See `docs/agents/issue-tracker.md`.

### Triage labels

Default five-label vocabulary (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`). See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: `GLOSSARY.md` and `docs/adr/` at the repo root. See `docs/agents/domain.md`.
