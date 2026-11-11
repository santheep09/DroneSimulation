# Phase 1 Tasks

> Claude Code: keep this file up to date. One task at a time. When a task is done, tick it, add the commit hash, and note gotchas in NOTES.md. Split any task that grows past ~2 h.

> Commit hashes in this file refer to the pre-baseline history, archived locally when the public history was squashed on 2026-11-11 (D-022).

- [x] **1.1 First session (plan mode, no changes).** Read CLAUDE.md + this phase's BRIEF; summarise the working rules in ≤ 5 lines.
- [x] **1.2 Environment check (read-only).** Report git, git-lfs, Python, uv/pip, Unity Hub + Unity 6 editor, Node (only if the Unity MCP needs it), and whether this folder is a git repo. List what's missing and how to install it.
- [x] **1.3 Repo + structure.** Propose → approve → create: folders per BRIEF, `.gitignore` (Unity: Library, Temp, Logs, UserSettings, Builds, *.csproj, *.sln; Python: .venv, __pycache__, data, runs), `.gitattributes` (LFS: *.fbx, *.psd, *.exr, *.tga, large *.png under RoverSim/Assets). Also git-ignore `.claude/settings.local.json` and `CLAUDE.local.md`. Move the outdated `HANDOFF_PROMPT.md` to `docs/archive/`. `git init`, first commit, create the GitHub repo (`gh repo create`), push. (68b2aaa)
- [x] **1.4 Unity 6 project in `/RoverSim`.** Claude Code gives exact Unity Hub steps; **you** create it (URP template). Set Force Text, Visible Meta Files, Rider external editor. Check `git status` stays clean after opening. (9bbc8fe + first-open settings commit)
- [x] **1.5 Headless Unity tests.** Add a Test Assembly (EditMode) with one trivial test; write `infra/unity_test.sh` (`-batchmode -projectPath sim -runTests -testPlatform EditMode -testResults …`); confirm exit code 0. (6092ce9)
- [x] **1.6 Python envs (D-011).** `ml/`: uv project on Python 3.12, torch + numpy + pytest, MPS smoke test. `rl/`: uv project on Python 3.10.12 with torch~=2.2 + `mlagents` matched to the chosen Unity package (4.0.x vs 4.1.0), and `mlagents-learn --help` works. Update D-005/D-011. Extend `infra/setup_check.sh` (already exists, from docs/SETUP.md) to check both envs. (8a7b488, 292c81c, 35b6e17)
- [x] **1.7 Unity MCP (read-only, D-012).** Add `com.unity.ai.assistant` to the project; start the bridge (Project Settings → AI → Unity MCP Server); Claude Code checks the current official docs, then walks you through connecting it and approving the client, step by step. Set `.claude/settings.json` permissions so only read tools are allowed. Test: list the scene hierarchy, read the Console. Write down in NOTES.md what it can and can't do. (a1ee063)
- [x] **1.8 Workflow rehearsal slice.** Full loop on one small Build-mode feature: an Editor menu item `RoverSim/Environment Info` that logs Unity version, fixed timestep and render pipeline, plus an EditMode test asserting the fixed timestep is 0.002 s (500 Hz, D-004). Plan mode → implement → `infra/unity_test.sh` → commit → tick. (c728700)
- [x] **1.9 Claude Code project config** (one sub-step per commit):
  - [x] a. `.claude/settings.json`: permissions (allow/ask/deny from §4.4), `defaultMode: default`; `.gitignore` has `.claude/settings.local.json` and `CLAUDE.local.md` (2bb1b16)
  - [x] b. Hooks: `session_context.sh` (SessionStart), `py_lint.sh` (PostToolUse on *.py); user-level macOS Notification hook in `~/.claude/settings.json` (07e8d98, notify hook pending)
  - [x] c. Rules: `.claude/rules/unity-csharp.md`, `python.md` (path-scoped); slim CLAUDE.md Conventions to point at them (25cd927)
  - [x] d. Skills: `.claude/skills/phase-status`, `phase-verify` (`context: fork`) (f35e4f8)
  - [x] e. Subagents: `.claude/agents/test-runner.md`, `code-reviewer.md`, `phase-verifier.md` (c053a30)
  - [x] f. Status line (model, context %, branch); optional: `csharp-lsp` + `pyright-lsp` plugins (8b092a5; LSP plugins skipped)
  - [x] g. Verify: `/context` shows CLAUDE.md, `/hooks`, `/agents`, `/permissions` list everything; `/doctor prompt-audit` has no major findings (de9402b)
- [x] **1.10 Wrap up.** `/phase-verify`, record the demo, write RETRO.md, update the master plan status. Then draft the Phase 2 brief.
