# Phase 2 Tasks: Rover design + ROS 2 dev environment

> Claude Code: keep this file up to date. One task at a time; say which. On completion: tick, add the commit hash, note gotchas in NOTES.md. Split any task that grows past ~2 h. Commit subjects start with the task id (`2.N:`).
>
> Tasks marked *pre-baseline* were done before the public history was squashed (D-022); their hashes are in the archived history.

## Setup
- [x] **2.1 Setup.** matplotlib in the `ml` dev group; `ml/roversim_ml/plotting.py` (headless Agg, byte-identical PNGs, tested); `GLOSSARY.md` stub. *(pre-baseline)*
- [x] **2.2 Plan v4.** D-019 to D-021; master plan, problem statement, README, CLAUDE.md, coding standards, rules and reviewer agent moved from NED to ENU/FLU. *(pre-baseline)*
- [x] **2.3 Session hook.** `session_context.sh` reports the first phase with open tasks instead of the first TASKS.md alphabetically. *(pre-baseline)*
- [x] **2.4 Project-only repo (D-022).** Learning material moved out of the repo; public history squashed into one baseline commit. (4f75b9b)

- [ ] **2.4a Rename to RoverSimulation (D-023).** Repo, Unity folder `RoverSim/`, namespace `RoverSim.*`, Python `roversim-*`; tests green before and after.

## ROS 2 dev environment
- [ ] **2.5 Choose distro and viewer (≈1.5 h).** Current official docs: ROS 2 distro (LTS, arm64 images), macOS viewer path (RViz over VNC vs Foxglove). *Done:* D-021 updated with the choice and links.
- [ ] **2.6 Container (≈2 h).** `infra/ros2/` Dockerfile + `compose.yaml` + README; workspace mount for later ROS 2 packages. *Done:* container starts; `ros2 doctor` passes.
- [ ] **2.7 Smoke test (≈1.5 h).** Talker/listener and a static + dynamic tf tree shown in the viewer; a scripted check in `infra/ros2/` exits 0. *Done:* recording or screenshot in `media/`.

## Rover dynamics spec
- [ ] **2.8 Spec outline + parameter table (≈1.5 h).** `docs/specs/ROVER_DYNAMICS_SPEC.md` headings; state vector, frames, parameters with units and sources.
- [ ] **2.9 Models (≈2 h).** Differential-drive / skid-steer kinematics, wheel-slip model, terrain friction (sand vs rock), motor lag.
- [ ] **2.10 Integration and control (≈2 h).** Integrator (D-016), 500 Hz wheel-speed loop, 50 Hz velocity/heading loop, pure pursuit (D-004); determinism (D-017).
- [ ] **2.11 ROS 2 interface (≈1.5 h).** Topics, message types, frame ids (`map`, `odom`, `base_link`), rates, QoS.
- [ ] **2.12 Test cases + review (≈2 h).** Numbered test cases (straight line, spin in place, arc radius, slip on sand, step response, loop-rate check); `/code-review` Spec axis. *Done:* no TODOs.

## Close
- [ ] **2.13 Close (≈2 h).** Demo; `/phase-verify`; RETRO.md; master plan status; Phase 3 brief.

## Stretch (first to cut)
- [ ] **2.S1 Python reference rover model (≈3 h).** Implements the spec's test cases; used to cross-check Phase 3.
- [ ] **2.S2 Gazebo diff-drive comparison (≈3 h).**
