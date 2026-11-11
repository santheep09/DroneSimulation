# Coding standards

Read by the `/code-review` Standards axis. Short on purpose; the fixed decisions live in `docs/DECISIONS.md` and the rules in `.claude/rules/`.

## Always
- Dynamics in SI units, world ENU and body FLU (ROS REP 103). Convert to Unity at the single boundary class only; no ENU/SI types touching `Transform` elsewhere. ENU up is positive z. (D-003, D-020)
- 500 Hz fixed physics step with cascaded control. (D-004)
- Custom label capture; no Unity Perception. (D-002)
- Anything that generates data or runs simulation takes a seed and is deterministic: no `UnityEngine.Random`, unseeded RNG or wall-clock time.
- Do not contradict an Accepted entry in `docs/DECISIONS.md`.

## Unity / C#
See `.claude/rules/unity-csharp.md`. Highlights: no allocations or LINQ in `FixedUpdate` or per-step paths, one MonoBehaviour per file, `_camelCase` private fields, PascalCase members.

## Python
See `.claude/rules/python.md`. Highlights: `uv` only, type hints, ruff-clean, pytest coverage, explicit seeds.

## Repo hygiene
- Never commit `DroneSim/Library`, `Temp`, `Logs`, `UserSettings`, `Builds`, `.venv`, datasets or training runs.
- One TASKS.md task per commit; no scope creep beyond the task.
- No personal details in tracked files or commit messages.
