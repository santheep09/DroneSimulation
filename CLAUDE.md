# CLAUDE.md: Search-and-Rescue Drone Simulator

## Project
Unity 6 quadrotor simulator. A drone searches procedurally generated biomes (dunes, rocky wadis, urban blocks, mangroves) for people and vehicles. One sim core feeds: (1) a synthetic aerial dataset + object detector, (2) an RL search policy (ML-Agents 4.x), (3) an agent evaluation harness (VLM-issued mission commands, scored on success/safety/cost). Portfolio project.

## About me
Personal context lives in `CLAUDE.local.md` (gitignored, loaded automatically). **Never copy personal details (background, employer, location, hardware, career plans, subscription) into any tracked file or commit message.** A hook enforces this. Skip engine/C# basics; ML, RL and drone physics are learning topics.

## Read first
(`docs/CLAUDE_CODE_GUIDE.md` describes the intended Claude Code setup: hooks, agents, skills. Read it for task 1.9.)
`docs/00_MASTER_PLAN.md` → `docs/DECISIONS.md` → `docs/WORKFLOW.md` → the current phase's `BRIEF.md` and `TASKS.md` under `docs/phases/`.

## Two working modes
**Learning mode**: ML, RL mechanics, quadrotor dynamics and control, coordinate frames, metrics (IoU, mAP, NMS), PPO.
- **I write the implementation.** You teach: explain the concept, give hints, ask me questions, review my code, point out bugs by asking leading questions first.
- You **may write tests** (e.g. IoU/NMS tests, frame sign/round-trip tests) and scaffolding (file stubs, plotting helpers) when asked.
- Never paste a full solution unless I explicitly say "show me the solution".
- Catch misconceptions directly. Two I had: quadrotors yaw via reaction torque between rotor pairs (no tail rotor); NED climbing is **negative z**.
- End each learning session by suggesting a LEARNING_LOG entry (`/log`).

**Build mode**: Unity/C# engine work, tooling, CLI scripts, repo infrastructure, data plumbing, CI, docs.
- You implement directly, following the rules below. Explain non-obvious choices briefly.

If unsure which mode a task is in, **ask**. Default to Learning mode for anything in Phase 2.

## Working rules
- One TASKS.md task at a time; say which one at session start.
- **Plan mode** before changes touching more than 3 files, any new system, or anything in a new phase.
- After each task: run the checks → small commit with a clear message → tick TASKS.md with the hash → gotchas to NOTES.md.
- Never commit `sim/Library`, `Temp`, `Logs`, `UserSettings`, `Builds`, `.venv`, datasets, training runs.
- Everything that generates data or runs simulation takes a **seed** and is deterministic.
- Prefer headless CLI steps (`-batchmode`, `-runTests`, `-executeMethod`) so results can be checked without the Editor. When the Editor is required, tell me exactly what to click or check.
- Unity MCP is **read-only** until DECISIONS.md says otherwise.
- Don't contradict DECISIONS.md; propose a new D-xxx entry first.
- Look up current docs for fast-moving tools (Unity MCP, ML-Agents, uv) instead of relying on memory.

## Fixed technical decisions (see DECISIONS.md)
- Dynamics in **SI units, NED frame**; convert to Unity at **one boundary class** only.
- **500 Hz** fixed physics step (`Time.fixedDeltaTime = 0.002`); cascaded control (fast inner attitude/rate loop, slower outer position loop).
- Custom label capture (no Unity Perception): segmentation, 2D boxes, COCO export.

## Layout
`sim/` Unity 6.6 project, pinned to 6000.6.2f1 (D-013: never upgrade mid-phase) (C# namespace `DroneSim.*`) · `ml/` Python 3.12 + current PyTorch (uv) · `rl/` Python 3.10.12 + torch 2.2 + mlagents (uv; ML-Agents requires it) · `learning/` Phase 2 exercises · `infra/` scripts · `docs/` plan, decisions, phases, learning log.

## Conventions
- C#: PascalCase types/methods, `_camelCase` private fields, one MonoBehaviour per file, NED/SI types never touch `Transform` outside the boundary class.
- Python: type hints, ruff, small testable functions, pytest.

## Commands (fill in as they're created)
- Setup check: `infra/setup_check.sh`
- Unity tests (headless): `infra/unity_test.sh`
- Python tests: `cd ml && uv run pytest`
- Slash commands: `/phase-status`, `/log`, `/phase-verify`
