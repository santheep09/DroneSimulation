# Decision Log

Format: ID · date · decision · status (Proposed / Accepted / Superseded) · reasoning. Add new entries at the bottom; never delete old ones. Mark them Superseded instead.

---

### D-001 · 2026-10-07 · Engine: Unity 6 first; port part of it to Unreal later · **Accepted**
- Strong existing Unity experience; native on Apple Silicon. Unreal port on a Windows machine in Phase 7 shows cross-engine range.
- Update 2026-11-10: the Unreal port is now optional and outside the phase gates (D-015). Unity-first stands.

### D-002 · 2026-10-07 · Build our own label capture (no Unity Perception) · **Accepted**
- Unity Perception is no longer developed: last release 1.0.0-preview.1 (2022-11-17), targeting Unity 2021.3/2022.x, not Unity 6.
- Custom capture: semantic segmentation, 2D bounding boxes, COCO export.

### D-003 · 2026-10-07 · Dynamics in SI units, NED frame; convert to Unity at exactly one boundary class · **Frame part superseded by D-020**
- NED: x North, y East, z Down (climbing = negative z). Unity: left-handed, y up.
- All physics and control code works in NED/SI; only the boundary class touches Unity transforms.

### D-004 · 2026-10-07 · Fixed physics step 500 Hz; cascaded control · **Accepted**
- Fast inner attitude/rate loop, slower outer position loop (Phase 2 experiment: 500 Hz inner / 50 Hz outer).

### D-005 · 2026-10-07 · RL with Unity ML-Agents 4.x · **Accepted**
- The original plan said 4.0.x. **Chosen (TASKS 1.6, 2026-11-06): Unity package `com.unity.ml-agents` 4.1.0** (released 2026-07-27, latest, no 4.1.x patch). It fixes a Play-mode exit crash, IL2CPP protobuf issues and `StackingSensor`; the 4.1 install docs describe it.
- Python side: **`mlagents==1.1.0`** from PyPI (newest release, Oct 2024). The 4.1 install docs pair it with Python 3.10.12. PyPI has no newer `mlagents`; the gymnasium migration in 4.1.0 exists only on GitHub, not in the PyPI wheel.
- Not yet verified: the real Unity-to-Python handshake. That happens when the package is added to `DroneSim/` (Phase 3 handshake smoke test). 1.6 only proves `mlagents-learn` installs and runs.

### D-006 · 2026-10-07 · Tooling budget (details kept privately) · **Accepted**

### D-007 · 2026-11-05 · Source control: git + GitHub + Git LFS for this portfolio · **Accepted**
- Portfolio repo; reviewers browse GitHub. LFS for binary art. Datasets and training runs are never committed.

### D-008 · 2026-11-05 · Isaac Sim is not an option on the Mac · **Accepted**
- Isaac Sim supports only Ubuntu 22.04/24.04 and Windows 10/11 with a high-end RTX GPU. If ever used, it goes on a Windows machine.

### D-009 · 2026-11-05 · Working mode for Claude Code in this repo · **Accepted** (revised 2026-11-11 by D-022)
- Claude implements project work directly (engine, tooling, infrastructure, docs), as defined in `CLAUDE.md`. Personal learning is kept outside this repo (D-022).

### D-010 · 2026-11-05 · Plan in phases, not weeks · **Accepted**
- Phases end on exit criteria, not dates. Week numbers in the master plan are a guide only.

### D-011 · 2026-11-05 · Two Python environments, both managed by uv · **Accepted** (confirmed in TASKS 1.6, 2026-11-06)
- ML-Agents 4.x requires Python 3.10.1–3.10.12 and `torch~=2.2.1`. That's too old to be the main ML env.
- `ml/` → Python 3.12 + current PyTorch (MPS) for the detector and datasets (Phase 5) and helpers.
- `rl/` → Python 3.10.12 + torch 2.2.x + `mlagents` (version matched to the Unity package) for RL (Phase 6) and the ML-Agents handshake (Phase 3).
- Replaces the single-env part of D-005.
- Resolved versions: `ml/` Python 3.12.16, torch 2.15.0, numpy 2.5.4 (MPS available). `rl/` Python 3.10.12, torch 2.2.2, mlagents 1.1.0, numpy 1.23.5, protobuf 3.20.3.
- `rl/` workarounds: `grpcio` overridden to `>=1.49,<=1.53.2` (mlagents caps 1.48.2, which has no arm64 macOS wheel); `setuptools<81` (mlagents imports `pkg_resources`); `uv.lock` limited to Apple silicon via `tool.uv.environments`.

### D-012 · 2026-11-05 · Unity MCP read-only enforced via Claude Code permissions · **Accepted** (confirmed in TASKS 1.7, 2026-11-06)
- The Unity MCP docs list no read-only mode; access control is only client approval (Allow/Revoke).
- Server: user-scope `unity-mcp` (created by Unity's Integrations tab; the path contains the home dir, so it stays out of the repo). Rules in `.claude/settings.json`: **allow** `Unity_GetConsoleLogs`; **ask** `Unity_RunCommand` and the capture tools and `GetModels`; **deny** `Unity_AssetGeneration_GenerateAsset`.
- Limit: the server has no hierarchy-reading tool, and `Unity_RunCommand` runs arbitrary C# that a permission rule can't tell read from write. Hierarchy reads go through `RunCommand` with a read-only script the user approves each time. Read-only is therefore enforced by the user's per-call approval, not by the rule alone. Revisit if Unity adds dedicated read tools.

### D-013 · 2026-11-05 · Unity version: 6.6, pinned to 6000.6.2f1 · **Accepted**
- Already installed and newest; meets the ML-Agents 4.x (6000.0+) and Unity MCP (Unity 6+) requirements.
- Considered 6.3 LTS (supported to Dec 2027, most-tested packages). Chose 6.6 to stay on one, current editor.
- Rules: the exact editor version is recorded in `DroneSim/ProjectSettings/ProjectVersion.txt` and README; **no editor upgrades mid-phase**. Any upgrade happens only at a phase boundary, as a new D-xxx entry, with determinism tests and benchmarks re-run before and after.
- Risk: ML-Agents / `com.unity.ai.assistant` are documented against LTS. Check both install cleanly in Phase 1 (TASKS 1.6, 1.7); if either fails, revisit this decision.

### D-014 · 2026-11-06 · Unity project folder is `DroneSim/` (was `sim/`) · **Accepted**
- The Unity project was created as `DroneSim` and kept; it matches the `DroneSim.*` C# namespace.
- All earlier references to `sim/` (BRIEF, CLAUDE.md, ignore rules, permissions) now mean `DroneSim/`.

### D-015 · 2026-11-10 · Plan v3: vertical slices, ramp-up before ML and RL, eval harness early · **Accepted** (Phase 2 scope and vehicle superseded by D-019)
- Replaces the phase order and Phase 2 scope in the master plan (not D-001 to D-014).
- Order: 2 Drone fundamentals · 3 Sim core + mission API v0 · 4 Eval harness slice · 5 Perception · 6 RL (time-boxed) · 7 Polish and showcase. Unreal port is optional and gates nothing.
- Phases 5 and 6 open with a short ramp-up on the ML and RL concepts they use.
- Detector and RL policy become agents on the Phase 4 leaderboard, so the three outputs are one system.
- Every phase has a must-have, a stretch and a publish. Cut order: Unreal port, coverage search and 3-train/1-test RL, fourth biome, detector-as-tool, reference-sim comparison.
- Still to decide, each before the phase that needs it: real-image dataset and licence (before Phase 5), scoring definitions for success/safety/cost (before Phase 4), biome count and order (before Phase 3 ends), compute plan and trigger to leave the Mac (before Phase 5).

### D-016 · 2026-11-10 · Custom integrator; no Rigidbody forces for the drone · **Accepted** (extended to all vehicles by D-019)
- Dynamics are integrated by our own code in `FixedUpdate` (D-003, D-004); the result is written to the Unity transform at the boundary class only.
- Reason: PhysX is not deterministic across machines and would hide the dynamics this project is meant to show.

### D-017 · 2026-11-10 · Determinism contract: same-machine bitwise replay from a seed · **Accepted**
- Same build, same machine, same seed and same command sequence give bit-identical state traces. The determinism tests assert exactly this.
- Cross-machine and cross-editor-version identity is not promised; the tests are re-run before and after any change per D-013.

### D-018 · 2026-11-10 · RL acts on setpoints at a reduced rate over the cascaded controller · **Proposed** (confirm before Phase 6)
- The policy outputs velocity or waypoint setpoints at about 10 to 50 Hz (decimation of the 500 Hz physics); it never commands rotors directly.
- Exact rate and action space are fixed after the Phase 3 mission API exists and the ML-Agents handshake smoke test has run.

### D-019 · 2026-11-11 · Plan v4: rover first; drone optional later · **Accepted**
- Supersedes the Phase 2 scope and the vehicle choice in D-015. Everything else in D-015 stays: vertical slices, just-in-time ML and RL blocks (Phases 5 and 6), evaluation early, must-have / stretch / publish per phase.
- Phase 2 becomes **Rover design + ROS 2 dev environment**: a ROS 2 container in `infra/ros2/` and the rover dynamics spec (`docs/specs/ROVER_DYNAMICS_SPEC.md`) that Phase 3 implements.
- Phase 3 builds a **4-wheel skid-steer ground rover** in the existing biomes. Search and rescue for people and vehicles stays the mission.
- Phase 4 is reframed as a **validation pipeline**: scenario files, scoring, a ROS 2 software-in-the-loop agent next to the scripted and VLM agents, CI in Docker.
- Optional after Phase 7, in priority order: a **lunar biome** (gravity as a parameter, no GPS), a **cross-simulator comparison** (CARLA or Gazebo, replacing the optional Unreal port), the **drone** as a second vehicle on the same platform.
- D-016 (custom integrator, no Rigidbody forces) applies to every vehicle, not only the drone.
- Repo name, the `DroneSim/` folder and the `DroneSim.*` namespace stay (D-014; renaming is churn with no gain). Docs call the project the search-and-rescue rover simulator.
- Why: a ground vehicle is the simpler first vehicle (no attitude control to fly) and matches off-road autonomy simulation work more closely; ROS 2 is the interface most robotics stacks expect.

### D-020 · 2026-11-11 · Frames: ENU world, FLU body (ROS REP 103) · **Accepted**
- Supersedes the frame part of D-003. SI units and **one boundary class** to Unity stay.
- World: ENU (x East, y North, z Up; climbing is **positive z**). Body: FLU (x Forward, y Left, z Up). Both right-handed. Unity is left-handed, y up; only the boundary class converts.
- ROS 2 uses REP 103, so no conversion is needed at the ROS boundary. A later drone uses the same frames.
- D-004 stands: 500 Hz physics, cascaded control. For the rover the inner loop is wheel speed (500 Hz) and the outer loop is velocity / heading / path (50 Hz).

### D-021 · 2026-11-11 · ROS 2 is the external interface; it runs in Docker on Linux · **Accepted**
- The sim talks to autonomy code through ROS 2 topics (`cmd_vel`, `odom`, tf, sensor messages). This enables software-in-the-loop tests.
- ROS 2 runs in a Linux (Ubuntu) container on the Mac. Distro and the visualisation path on macOS (RViz over VNC or Foxglove) are chosen in Phase 2 (TASKS 2.5) from current official docs.
- The Unity-side bridge technology is chosen at the start of Phase 3, also from current docs.
- Headless Linux builds of the sim in Docker feed CI in Phase 4.

### D-022 · 2026-11-11 · The repo holds the project only; learning material is kept outside it · **Accepted**
- This public repo contains the simulator, its infrastructure, design docs and the engineering workflow, so it can be shared as a reference.
- Personal learning material (exercises, notes, progress) lives in a separate local workspace and is never committed here.
- Public history was squashed into one baseline commit on 2026-11-11; older commit hashes quoted in Phase 1 docs refer to the archived pre-baseline history.
