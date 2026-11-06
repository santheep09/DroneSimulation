# Decision Log

Format: ID · date · decision · status (Proposed / Accepted / Superseded) · reasoning. Add new entries at the bottom; never delete old ones. Mark them Superseded instead.

---

### D-001 · 2026-10-07 · Engine: Unity 6 first; port part of it to Unreal later · **Accepted**
- Strong existing Unity experience; native on Apple Silicon. Unreal port on a Windows machine in Phase 7 shows cross-engine range.

### D-002 · 2026-10-07 · Build our own label capture (no Unity Perception) · **Accepted**
- Unity Perception is no longer developed: last release 1.0.0-preview.1 (2022-11-17), targeting Unity 2021.3/2022.x, not Unity 6.
- Custom capture: semantic segmentation, 2D bounding boxes, COCO export.

### D-003 · 2026-10-07 · Dynamics in SI units, NED frame; convert to Unity at exactly one boundary class · **Accepted**
- NED: x North, y East, z Down (climbing = negative z). Unity: left-handed, y up.
- All physics and control code works in NED/SI; only the boundary class touches Unity transforms.

### D-004 · 2026-10-07 · Fixed physics step 500 Hz; cascaded control · **Accepted**
- Fast inner attitude/rate loop, slower outer position loop (Phase 2 experiment: 500 Hz inner / 50 Hz outer).

### D-005 · 2026-10-07 · RL with Unity ML-Agents 4.x · **Accepted**
- The original plan says 4.0.x. As of Jul 2026, com.unity.ml-agents **4.1.0** is out. Pick and pin one in Phase 1 and match the `mlagents` Python package to it.

### D-006 · 2026-10-07 · Tooling budget (details kept privately) · **Accepted**

### D-007 · 2026-11-05 · Source control: git + GitHub + Git LFS for this portfolio · **Accepted**
- Portfolio repo; reviewers browse GitHub. LFS for binary art. Datasets and training runs are never committed.

### D-008 · 2026-11-05 · Isaac Sim is not an option on the Mac · **Accepted**
- Isaac Sim supports only Ubuntu 22.04/24.04 and Windows 10/11 with a high-end RTX GPU. If ever used, it goes on a Windows machine.

### D-009 · 2026-11-05 · Two working modes for Claude Code: Learning and Build · **Accepted**
- Learning mode for ML, RL mechanics and drone physics (I write the code). Build mode for engine, tooling and infrastructure. Defined in `CLAUDE.md`.

### D-010 · 2026-11-05 · Plan in phases, not weeks · **Accepted**
- Phases end on exit criteria, not dates. Week numbers in the master plan are a guide only.

### D-011 · 2026-11-05 · Two Python environments, both managed by uv · **Proposed** (confirm in TASKS 1.6)
- ML-Agents 4.x requires Python 3.10.1–3.10.12 and `torch~=2.2.1`. That's too old to be the main ML env.
- `ml/` → Python 3.12 + current PyTorch (MPS) for Phase 2a and Phase 4 (detector, datasets).
- `rl/` → Python 3.10.12 + torch 2.2.x + `mlagents` (version matched to the Unity package) for Phase 2b and Phase 5.
- Replaces the single-env part of D-005.

### D-012 · 2026-11-05 · Unity MCP read-only enforced via Claude Code permissions · **Proposed** (confirm in TASKS 1.7)
- The Unity MCP docs list no read-only mode; access control is only client approval (Allow/Revoke).
- Read-only means: allow only read tools (scene/hierarchy reading, console reading) in `.claude/settings.json`; deny or ask for scene/asset-modifying tools until this entry is superseded.

### D-013 · 2026-11-05 · Unity version: 6.6, pinned to 6000.6.2f1 · **Accepted**
- Already installed and newest; meets the ML-Agents 4.x (6000.0+) and Unity MCP (Unity 6+) requirements.
- Considered 6.3 LTS (supported to Dec 2027, most-tested packages). Chose 6.6 to stay on one, current editor.
- Rules: the exact editor version is recorded in `DroneSim/ProjectSettings/ProjectVersion.txt` and README; **no editor upgrades mid-phase**. Any upgrade happens only at a phase boundary, as a new D-xxx entry, with determinism tests and benchmarks re-run before and after.
- Risk: ML-Agents / `com.unity.ai.assistant` are documented against LTS. Check both install cleanly in Phase 1 (TASKS 1.6, 1.7); if either fails, revisit this decision.

### D-014 · 2026-11-06 · Unity project folder is `DroneSim/` (was `sim/`) · **Accepted**
- The Unity project was created as `DroneSim` and kept; it matches the `DroneSim.*` C# namespace.
- All earlier references to `sim/` (BRIEF, CLAUDE.md, ignore rules, permissions) now mean `DroneSim/`.
