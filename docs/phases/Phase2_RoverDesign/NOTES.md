# Phase 2 Notes

Findings, gotchas and links, kept by Claude Code. One heading per task id.

## 2.1
- `ml/roversim_ml/plotting.py` uses matplotlib's object API (`Figure` + Agg canvas), not pyplot, so it needs no GUI backend and PNG output is byte-identical for identical input (tested).
- matplotlib 3.11.2 added to the `ml` dev group (uv.lock updated).

## 2.4
- The repo holds the project only (D-022). Public history was squashed into one baseline commit on 2026-11-11; hashes quoted in Phase 1 docs refer to the archived pre-baseline history.

## 2.4a
- Rename to RoverSimulation (D-023). After a fresh clone or folder move, delete each `.venv` and run `uv sync` (venvs store absolute paths).
- Unity regenerates the `.csproj`/`.sln` files under the new names; the old generated `DroneSim.*` ones were deleted.
- A headless Unity run again drifted `ProjectSettings.asset` (the `SENTIS_ANALYTICS_ENABLED` define) and `ProjectAuditorSettings.asset`; both reverted before commit, as in Phase 1 NOTES.
