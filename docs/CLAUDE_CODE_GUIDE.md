# Claude Code Guide for the Drone Simulator

How to get the best results from Claude Code on this project: the mental model, every building block, where each file lives, and the exact setup we'll build in Phase 1.
Checked against the Claude Code docs on 2026-11-05 (your version: 2.1.285). Features move fast. When in doubt, ask Claude Code itself ("how do I … in Claude Code?") or see https://code.claude.com/docs.

---

## 1. The mental model (read this first)

Claude Code is an **agent loop**: it reads files, runs commands, edits code, checks the result, and repeats until it thinks the task is done. Two facts drive almost every best practice:

1. **The context window is the scarce resource.** Every message, file read and command output fills it, and quality drops as it fills. Most of the habits below exist to keep context small and relevant.
2. **Claude stops when the work *looks* done.** Give it a check it can run (tests, a script, an exit code) and it will iterate until the check passes. Without one, *you* become the test suite.

You steer Claude Code with four layers. Each has a different strength:

| Layer | Feature | Strength | Use for |
|---|---|---|---|
| **Know** | `CLAUDE.md`, `.claude/rules/`, auto memory | Always loaded; *advisory* | Project facts, conventions, commands |
| **Do** | Skills, subagents, MCP servers, plugins | Loaded on demand | Repeatable workflows, specialists, external tools |
| **Guard** | Permissions, hooks | *Deterministic*: runs every time | Things that must always / never happen |
| **Habits** | Plan mode, `/clear`, verify, commit, rewind | Your discipline | Keeping sessions sharp |

> **Key rule:** CLAUDE.md is a *request*. A hook or a permission rule is a *guarantee*. If something must never happen (e.g. Claude writing your Phase 2 learning code), enforce it with a hook, not just a sentence.

---

## 2. Where everything lives

Two levels: **user** (`~/.claude/`, applies to all your projects, never committed) and **project** (inside this repo, committed so it's reproducible). `*.local.*` files are project-level but personal (git-ignored).

```
~/.claude/                         ← USER level (this Mac, all projects)
  CLAUDE.md                        personal preferences for every project (keep tiny)
  settings.json                    personal settings: notifications hook, status line, model
  skills/  agents/  rules/         personal skills/agents/rules for every project
~/.claude.json                     Claude Code's own state + local/user-scope MCP servers

DroneSimulation/                   ← PROJECT level (committed to git)
  CLAUDE.md                        project instructions, loaded every session (< 200 lines)
  CLAUDE.local.md                  personal project notes (git-ignored)
  .mcp.json                        project MCP servers (Unity MCP)
  .claude/
    settings.json                  permissions, hooks, defaults, shared (committed)
    settings.local.json            personal overrides, output style choice (git-ignored)
    rules/*.md                     topic rules, optionally path-scoped (e.g. only for DroneSim/**/*.cs)
    skills/<name>/SKILL.md         project skills = slash commands (/phase-status …)
    agents/<name>.md               project subagents (test-runner, code-reviewer …)
    hooks/*.sh                     scripts the hooks call
  docs/                            plans, decisions, phases (shared with claude.ai)
```

Note: `.claude/commands/*.md` still works, but **custom commands have been merged into skills**. Use `.claude/skills/` for new ones.

---

## 3. What we have now vs what's still needed

| Item | Status | Phase 1 task |
|---|---|---|
| `CLAUDE.md` (two modes, rules, stack) | ✅ ~70 lines, good size | Check with `/context`; audit with `/doctor prompt-audit` |
| Docs: plan, decisions, workflow, phase brief/tasks | ✅ | — |
| `HANDOFF_PROMPT.md` (Oct 7) | ⚠️ outdated, superseded by `docs/` | Move to `docs/archive/` in 1.3 |
| Tools installed (git, gh, uv, Unity, Claude Code) | ✅ | — |
| git repo, `.gitignore` (incl. `.claude/settings.local.json`, `CLAUDE.local.md`) | ❌ | 1.3 |
| `.claude/settings.json`: permissions + hooks | ❌ | **1.9** |
| `.claude/rules/` (C#, Python, learning) | ❌ | **1.9** |
| Skills: `/phase-status`, `/log`, `/phase-verify` | ❌ | **1.9** |
| Subagents: test-runner, code-reviewer, phase-verifier | ❌ | **1.9** |
| `.mcp.json`: Unity MCP (read-only) | ❌ | 1.7 |
| Code-intelligence plugins (C#, Python) | ❌ optional | **1.9** |
| Status line (context %, branch) | ❌ | **1.9** |
| User-level `~/.claude/CLAUDE.md` + notification hook | ❌ | **1.9** |

---

## 4. Each building block, and how we use it

### 4.1 CLAUDE.md: what Claude must always know
- Loaded at the start of **every** session. Locations, in load order: `~/.claude/CLAUDE.md` → `./CLAUDE.md` (or `./.claude/CLAUDE.md`) → `./CLAUDE.local.md`. Files in subfolders load when Claude touches files there.
- **Target under 200 lines.** For each line ask: *"Would removing this cause Claude to make mistakes?"* If not, cut it. Bloat makes Claude ignore the rules that matter.
- Include: commands Claude can't guess, rules that differ from defaults, architecture decisions (NED/SI boundary, 500 Hz), gotchas. Exclude: anything readable from the code, tutorials, things that change often.
- `@path/to/file` imports another file. That's convenient, but it still costs context.
- If Claude keeps ignoring one rule, mark *that one line* `IMPORTANT`. Emphasising many lines makes none of them stand out.
- Check it loaded: `/context` (look under **Memory files**). Audit it: `/doctor prompt-audit`.
- **Auto memory**: Claude also keeps its own notes per repo from your corrections (first 200 lines are loaded). Fine to leave on; review it occasionally.

### 4.2 Rules (`.claude/rules/*.md`): conventions only where they apply
- Same as CLAUDE.md but split by topic. With `paths:` frontmatter, a rule loads **only when Claude touches matching files**, which saves context.
- Our three:
  - `unity-csharp.md`, `paths: ["DroneSim/**/*.cs"]`: naming, one MonoBehaviour per file, NED/SI types never touch `Transform` outside the boundary class, no allocations in `FixedUpdate`, determinism (seeded RNG only).
  - `python.md`, `paths: ["ml/**/*.py", "rl/**/*.py"]`: uv only (never pip), type hints, ruff, pytest, seeds everywhere.
  - `learning-mode.md`, `paths: ["learning/**"]`: the full Learning-mode protocol (hints → leading questions → tests only → solution only on "show me the solution").
- Then the Conventions section in CLAUDE.md can shrink to one line pointing to rules.

### 4.3 Permission modes: how much Claude can do without asking
Switch with **Shift+Tab** (cycles modes; status bar shows the current one) or `--permission-mode`.

| Mode | Behaviour | When we use it |
|---|---|---|
| **Manual** (`default`) | Asks before edits, commands, MCP tools | **Phase 1**: you see and learn every action |
| **Plan** (`plan`) | Reads and explores, no edits | Start of every task touching > 3 files or a new system |
| `acceptEdits` | Auto-accepts file edits + basic fs commands | Once you trust a task's direction |
| `auto` | A classifier reviews actions, blocks risky ones; few prompts | **Default from v2.1.283.** Use from Phase 3 on for routine work |
| `dontAsk` / `bypassPermissions` | Only pre-approved / everything | Scripts and containers only. Not for us |

Your version (2.1.285) starts in **auto** mode by default. For Phase 1, set the default to Manual (`"permissions": {"defaultMode": "default"}`) so you learn what Claude actually does. Revisit at the Phase 1 retro.

### 4.4 Permission rules: pre-approve the safe, block the dangerous
In `.claude/settings.json`. Evaluated **deny → ask → allow**; the first match wins. A deny can't be overridden by a narrower allow.
```jsonc
{
  "permissions": {
    "defaultMode": "default",
    "allow": [
      "Bash(git status*)", "Bash(git diff*)", "Bash(git log*)",
      "Bash(git add *)", "Bash(git commit *)",
      "Bash(uv run pytest*)", "Bash(uv run ruff *)",
      "Bash(bash infra/*)", "Bash(infra/*)"
      // + Unity MCP *read* tools, named exactly after 1.7, e.g. "mcp__unity__Unity_ReadConsole"
    ],
    "ask":  [ "Bash(git push*)", "Bash(rm *)", "Bash(gh repo *)" ],
    "deny": [
      "Read(./.env)", "Read(./**/.env)",
      "Edit(/DroneSim/Library/**)", "Edit(/DroneSim/Temp/**)", "Edit(/datasets/**)", "Edit(/runs/**)"
    ]
  }
}
```
Use `/permissions` in a session to view or edit rules interactively. The "Yes, don't ask again" answers are saved for you too.

### 4.5 Hooks: guarantees
Scripts Claude Code runs itself at lifecycle events: `SessionStart`, `UserPromptSubmit`, `PreToolUse` (can **block** with exit 2), `PostToolUse`, `Stop` (can force Claude to keep going), `Notification`, `PreCompact`, `SubagentStop`, and more. Configured under `"hooks"` in a settings file; browse with `/hooks`. Claude can write hooks for you.

Our starter set (Phase 1, task 1.9):

| Hook | Event / matcher | What it does | Why |
|---|---|---|---|
| `session_context.sh` | `SessionStart` (startup, resume, clear, compact) | Prints the current phase, the next 5 open tasks from TASKS.md, `git status -s` | Every session starts oriented, with no re-explaining |
| `guard_learning.sh` | `PreToolUse` on `Edit\|Write` | **Blocks** (exit 2) writes under `learning/**` except test files and LEARNING_LOG, with the message *"Learning mode: the user writes this. Give hints."* | Enforces "teach, don't do" in Phase 2. A rule alone could be ignored |
| `py_lint.sh` | `PostToolUse` on `Edit\|Write`, `if: Edit(*.py)` | `uv run ruff format` + `ruff check`; problems go back to Claude | Python style without asking |
| macOS notify | `Notification` (user-level) | `osascript -e 'display notification "Claude needs you" with title "Claude Code"'` | Step away while it works |
| *(Phase 3)* determinism gate | `Stop` | Runs the quick determinism test; blocks "done" if it fails | Never claims success on broken determinism |

Shape of a hook entry:
```json
{ "hooks": { "PreToolUse": [ { "matcher": "Edit|Write",
  "hooks": [ { "type": "command", "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/guard_learning.sh" } ] } ] } }
```
The hook gets the event as JSON on stdin (tool name, file path …). Exit 0 means OK; exit 2 means block, with stderr shown to Claude as the reason.

### 4.6 Skills: reusable workflows and slash commands
A folder with `SKILL.md` (frontmatter + instructions, optionally helper scripts). You invoke one with `/name args`, or Claude loads it automatically when the `description` matches the task. Skills load **only when used**, unlike CLAUDE.md, so put procedures here, not in CLAUDE.md.

Key frontmatter: `name`, `description` (lead with when to use it), `disable-model-invocation: true` (only you can trigger it; use for anything with side effects), `allowed-tools`, `argument-hint`, `context: fork` (runs in a subagent so it doesn't fill your context). Arguments: `$ARGUMENTS`, `$0`, `$1` ….

Bundled skills worth knowing: `/code-review` (reviews the diff in a fresh subagent), `/verify`, `/debug`, `/simplify`, `/batch`, `/doctor`, `/skill-doctor` (context cost of your skills).

Our skills, added as each phase needs them:

| Phase | Skill | Does |
|---|---|---|
| 1 | `/phase-status` | Summarises the current phase: done, next, blockers |
| 1 | `/log` | Interviews you and appends a LEARNING_LOG entry (`disable-model-invocation`) |
| 1 | `/phase-verify` | Checks every exit criterion with evidence (`context: fork`) |
| 2 | `/quiz <topic>` | Diagnostic questions; tracks your score toward the 8/10 gate |
| 3 | `/unity-test [filter]` | Runs headless EditMode/PlayMode tests and summarises failures |
| 3 | `/determinism-check <seed>` | Runs a sim twice and diffs the state hashes |
| 4 | `/dataset-check <path>` | Validates a dataset: counts, label/class integrity, COCO schema |
| 5 | `/seed-sweep <config>` | Launches the 5-seed run and aggregates results |

Rule of thumb: **make a skill once you've typed the same multi-step instruction about 3 times.**

### 4.7 Subagents: specialists with their own context
A Markdown file in `.claude/agents/` with its own system prompt, tool allowlist and model. It starts with a **fresh context** (it doesn't see your chat), does its job, and returns only a summary. Two big wins: (1) heavy reading or log output stays out of your main context; (2) **an independent reviewer**: the agent that wrote the code isn't the one grading it.

Built-ins you get for free: **Explore** (read-only codebase search), **Plan** (research in plan mode), **general-purpose**.

Frontmatter: `name`, `description` (when to delegate; add "use proactively" to encourage it), `tools` / `disallowedTools`, `model` (`haiku`/`sonnet`/`opus`/`inherit`), `permissionMode`, `maxTurns`, `skills`, `isolation: worktree`, `memory`.

Our roster, staged by phase (create each one when its phase starts, not before):

| Phase | Agent | Tools | Model | Job |
|---|---|---|---|---|
| 1 | `test-runner` | Bash, Read, Grep | sonnet | Runs `infra/unity_test.sh` / pytest; returns only failures + likely cause |
| 1 | `code-reviewer` | Read, Grep, Glob (read-only) | inherit | Reviews the diff against CLAUDE.md + rules: Unity perf, determinism, NED boundary, scope creep. Flags only real problems |
| 1 | `phase-verifier` | Read, Grep, Glob, Bash | inherit | Fresh-context check of BRIEF exit criteria with evidence |
| 3 | `physics-reviewer` | read-only | inherit | Units, frames (NED↔Unity signs), mixer/yaw, loop rates, integrator stability |
| 4 | `dataset-auditor` | Read, Bash | sonnet | Label/frame alignment, class balance, leakage between splits |
| 5 | `rl-experiment-reviewer` | read-only | inherit | Seeds, train/test biome split, reward hacking, fair comparisons |

How to call one: it happens automatically from the `description`, or say *"use the code-reviewer subagent on this diff"*, or `@code-reviewer`. Remember: **subagents don't see your conversation.** Put must-follow rules in their own prompt.

### 4.8 MCP servers: connections to external tools
MCP gives Claude tools from other programs. Scopes: **local** (default, `~/.claude.json`, this project only, just you), **project** (`.mcp.json`, committed), **user** (all your projects). Add with `claude mcp add …`, manage with `/mcp`. Project servers need a one-time approval.

For us:
- **Unity MCP** (official, `com.unity.ai.assistant`), **project scope** in `.mcp.json`. Lets Claude read the scene hierarchy and Console and inspect objects. The docs list no read-only mode, so we allow only read tools in permissions and deny/ask the rest (D-012). Set up in task 1.7.
- **GitHub**: no MCP needed. The `gh` CLI is already logged in and is more context-efficient. CLAUDE.md says "use `gh` for GitHub".
- **Docs/search**: built-in WebFetch/WebSearch are enough. Don't add servers "just in case": every MCP server's tool list costs context in every session.

### 4.9 Plugins: packaged bundles
A plugin bundles skills, agents, hooks, MCP servers and language servers. Browse with `/plugin`. For us, only the **code-intelligence** ones are worth it now. They give Claude live compiler diagnostics after each edit and go-to-definition:
- **C#**: `csharp-lsp` (needs `csharp-ls`, a .NET tool, so it needs the .NET SDK). Works off Unity's generated `.sln`/`.csproj` (open the project in Rider once so they exist).
- **Python**: `pyright-lsp` (needs `pyright`).
Install: `/plugin install csharp-lsp@claude-plugins-official`. These are optional in 1.9; skip if setup fights you.

### 4.10 Output styles: how Claude talks
`/output-style <name>`: Default, Concise, Explanatory, **Learning**. The built-in **Learning** style leaves `TODO(human)` gaps for you to fill at real design decisions and adds "Insight" blocks. It fits **Phase 2** well, on top of our Learning-mode rule and hook. Use **Explanatory** while learning the Unity-side code Claude writes in Phase 3. The choice is saved in `settings.local.json`.

### 4.11 Status line
`/statusline` then e.g. *"show model, context % used, git branch, current phase"*. Watching context % is the easiest way to know when to `/clear` or `/compact`.

### 4.12 Headless and automation (later)
- `claude -p "prompt"`: one-shot, scriptable (`--output-format json`). Useful in Phase 4–5 to batch-analyse runs.
- GitHub Actions with Claude: PR reviews / `@claude` on issues. Consider it at Phase 3, once there are tests to run in CI.
- Git worktrees (subagent `isolation: worktree`, or separate sessions in separate worktrees): parallel work that doesn't collide. Handy in Phase 5 (one session training, one coding).

---

## 5. A working session, start to finish

```
1. cd DroneSimulation && claude            (or: claude --continue / --resume)
   → SessionStart hook prints phase + next tasks
2. /phase-status                            pick ONE task
3. Shift+Tab → Plan mode                    "Plan task 1.5. Read BRIEF + TASKS. Ask me anything unclear."
   Ctrl+G to edit the plan yourself → approve
4. Implement (Manual or acceptEdits)        Claude edits, you approve
5. Verify                                   test-runner subagent / infra scripts → evidence, not "done!"
6. Review                                   "use code-reviewer on the diff" or /code-review
7. Commit                                   "commit with a clear message, tick TASKS.md with the hash"
8. /clear                                   before the next unrelated task
```

**Context habits**
- `/clear` between unrelated tasks. If you've corrected Claude twice on the same thing, `/clear` and re-prompt better.
- `/compact <what to keep>` when a long task must continue. `/context` to see what's filling it.
- `/btw <question>` for a side question that shouldn't enter the history.
- `Esc` stops Claude mid-action; `Esc Esc` or `/rewind` restores code and/or conversation to an earlier point. Checkpoints only track Claude's file edits, not Bash side effects, so **git is still your real safety net**: commit often.
- `/rename phase1-repo-setup` to name sessions; `claude --resume` to find them later.

**Prompting habits**
- Be specific: file paths (`@DroneSim/Assets/...`), the constraint, and what "done" looks like (a test or command).
- For bigger features: *"Interview me with AskUserQuestion, then write a spec to docs/phases/…/SPEC_x.md"*, then start a **fresh** session to implement it.
- Ask for evidence: "show me the test output", not "is it working?".
- Point to patterns: "follow the style of `infra/unity_test.sh`".

---

## 6. Usage-limit tips
- Check usage with `/usage` (`/cost` is an alias). Limits are the constraint, so keep sessions focused.
- `/model` to switch models: a stronger model for planning and hard debugging, a lighter one for routine edits. Give mechanical subagents (`test-runner`) `model: sonnet` or `haiku`.
- Plan in claude.ai (this project) and execute in Claude Code. Long strategy chats inside Claude Code burn the coding budget.
- Every always-loaded thing (CLAUDE.md, rules without `paths`, MCP tool lists, skill descriptions) costs tokens in every session. Keep them lean; `/skill-doctor` shows skill costs.

---

## 7. Build order (don't do it all at once)

1. **Phase 1, before coding (tasks 1.3, 1.9):** `.gitignore` entries → `.claude/settings.json` (permissions, Manual default) → SessionStart + learning-guard + notify hooks → 3 rules → 3 skills → 3 agents → status line → (optional) LSP plugins.
2. **Use it for 1–2 weeks**, then prune at the Phase 1 retro: what got ignored, what got in the way?
3. **Add per phase** only what that phase needs (tables in 4.6 and 4.7).

The best setup grows from real friction: when you notice the same correction twice, turn it into a rule, a skill or a hook.

## 8. Cheat sheet

| Command / key | Does |
|---|---|
| `Shift+Tab` | Cycle permission modes (Manual / acceptEdits / Plan / auto) |
| `Esc` / `Esc Esc` | Stop / rewind menu |
| `Ctrl+G` | Edit the plan in your editor |
| `@file` | Attach a file to the prompt |
| `/clear` `/compact` `/context` | Reset / summarise / inspect context |
| `/rewind` `/resume` `/rename` | Checkpoints and sessions |
| `/permissions` `/hooks` `/agents` `/mcp` `/plugin` | Inspect / edit each layer |
| `/output-style` `/statusline` `/model` `/usage` | Style, status bar, model, limits |
| `/doctor`, `/doctor prompt-audit` | Health check; audit instructions for bloat and conflicts |
| `/code-review` `/verify` | Bundled review / verification |
| `claude --continue` `claude -p "…"` | Resume last session / headless one-shot |
