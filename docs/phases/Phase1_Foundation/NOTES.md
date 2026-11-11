# Phase 1 Notes

## 1.2 / 1.3 gotchas
- Node/npm not installed; probably not needed for the Unity MCP. Verify in 1.7.
- Running `git lfs env` outside a repo creates an `lfs/` folder in the cwd. Run it only inside a repo.
- `*.onnx` is deliberately NOT git-ignored (trained models may be committed as Unity assets). `*.pt`/`*.pth`/`*.ckpt` are ignored.
- PNG is LFS-tracked only under `DroneSim/Assets/`, so docs screenshots stay plain git.
- Repo: https://github.com/santheep09/DroneSimulation (`main`).

## 1.9 gotchas
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

## 1.6 Python envs
- `rl/` needs two workarounds (recorded in D-011): `grpcio` override (mlagents caps a version with no arm64 macOS wheel) and `setuptools<81` (mlagents imports `pkg_resources`).
- PyPI `mlagents` is 1.1.0 and pairs with Unity package 4.1.0; the real Unity-to-Python handshake is untested until the Phase 3 handshake smoke test.

## 1.8 / 1.9f
- Project fixed timestep was Unity's 0.02 default; now 0.002 in `TimeManager.asset` (D-004). The test failed red first, then green.
- Every headless Unity run drifts `ProjectSettings/ProjectSettings.asset` and `ProjectAuditorSettings.asset`: discard with `git checkout -- DroneSim/ProjectSettings/<file>` before committing.
- The statusline-setup subagent has no Bash tool: it can write files but not chmod or test them.

## 1.7 Unity MCP (read-only)
- Package `com.unity.ai.assistant` 2.21.0-pre.2 (pre-release). Bridge: Edit > Project Settings > AI > Unity MCP Server (auto-starts with the Editor). Unity's Integrations tab > Configure adds a **user-scope** server `unity-mcp` to Claude Code (not committed; it holds the home path). New tools load only at session start: start a new session after configuring.
- Tools (7): `Unity_GetConsoleLogs` (read), `Unity_Camera_Capture`, `Unity_SceneView_Capture2DScene`, `Unity_SceneView_CaptureMultiAngleSceneView` (renders), `Unity_AssetGeneration_GetModels`, `Unity_AssetGeneration_GenerateAsset` (write, third-party generation), `Unity_RunCommand` (compiles and runs C#).
- Permissions: allow console; ask for RunCommand/captures/GetModels; deny GenerateAsset (the deny removed it from the session's tool list).
- Can: read the Console, capture views, read the hierarchy via a read-only `RunCommand` script (tested: Main Camera, Directional Light). Cannot: dedicated hierarchy/inspector reads, or enforce read-only for RunCommand by name (limit recorded in D-012).
- The Editor must be closed for `infra/unity_test.sh`; an open Editor drifts `ProjectAuditorSettings.asset` (discard it).
- The privacy guard blocks Bash commands containing the home path: use relative paths or `$HOME`.

## 1.10 demo
- Opening the Editor can rewrite `ProjectSettings/VersionControlSettings.asset` (`m_Mode` from `Visible Meta Files` to `Unity Version Control`). Discard it; committing it would turn off Visible Meta Files.
- `setup_check.sh` prints hardware, memory and the git identity. Strip those lines before putting its output in any tracked file (see `media/demo.md`).
- `Error reason is 'NoSubscription'` in the Console comes from the AI generators in `com.unity.ai.assistant` when the account has no AI subscription. Harmless.
