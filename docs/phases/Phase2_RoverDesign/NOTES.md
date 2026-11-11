# Phase 2 Notes

Findings, gotchas and links, kept by Claude Code. One heading per task id.

## 2.1
- `ml/dronesim_ml/plotting.py` uses matplotlib's object API (`Figure` + Agg canvas), not pyplot, so it needs no GUI backend and PNG output is byte-identical for identical input (tested).
- matplotlib 3.11.2 added to the `ml` dev group (uv.lock updated).

## 2.4
- The repo holds the project only (D-022). Public history was squashed into one baseline commit on 2026-11-11; hashes quoted in Phase 1 docs refer to the archived pre-baseline history.
