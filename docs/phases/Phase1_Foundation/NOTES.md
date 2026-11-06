# Phase 1 Notes

## 1.2 / 1.3 gotchas
- Node/npm not installed; probably not needed for the Unity MCP. Verify in 1.7.
- Running `git lfs env` outside a repo creates an `lfs/` folder in the cwd. Run it only inside a repo.
- `*.onnx` is deliberately NOT git-ignored (trained models may be committed as Unity assets). `*.pt`/`*.pth`/`*.ckpt` are ignored.
- PNG is LFS-tracked only under `DroneSim/Assets/`, so docs screenshots stay plain git.
- Repo: https://github.com/santheep09/DroneSimulation (`main`).

## 1.9 gotchas
- `guard_learning.sh` only sees Edit/Write/NotebookEdit. A Bash redirect (`echo > learning/x.py`) bypasses it; `learning-mode.md` (1.9c) is the backstop.
- Guard allows `test_*.py`, `*_test.py` and anything under a `tests/` dir inside `learning/`.
- `py_lint.sh` is a no-op until `ml/` or `rl/` has a `pyproject.toml` (task 1.6).
- User-level macOS notification hook (`~/.claude/settings.json`) not yet added; needs your OK.
- Hook scripts verified by piping JSON; live in-session block still to be confirmed in a fresh session.

## 1.4 gotchas
- Unity Hub's "create git repository" option makes a nested `.git` plus a GitHub repo (with your git identity). Leave it off; the project lives in the main repo.
- First open re-serialises a few tracked assets (`DefaultVolumeProfile.asset`, `ProjectAuditorSettings.asset`, new `TimelineSettings.asset`). Harmless; commit them once.
- Project folder is `DroneSim/` (D-014), not `sim/`.
- Rider preference lives in `com.unity3d.UnityEditor5.x` (`kScriptsDefaultApp`); it saves when Unity quits normally.
- Template tutorial assets (`Readme.asset`, `TutorialInfo/`) are still present; one PNG is LFS-tracked.

## 1.5 gotchas
- `infra/unity_test.sh [filter]` needs every Unity Editor instance closed; first run compiles (a few minutes), later runs are fast.
- Exit codes: 0 pass, 2 test failures, 10/11 script preconditions. Results in `results/unity/` (git-ignored).
- Each headless run makes Unity rewrite `ProjectSettings/ProjectSettings.asset` (a `SENTIS_ANALYTICS_ENABLED` scripting define) and `ProjectAuditorSettings.asset`. This is noise; discard it with `git checkout -- DroneSim/ProjectSettings/` unless you changed settings on purpose.
- Licence activation worked in batchmode with the existing Hub login.
