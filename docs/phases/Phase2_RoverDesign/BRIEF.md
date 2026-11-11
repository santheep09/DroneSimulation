# Phase 2: Rover design + ROS 2 dev environment

**Status:** In progress · **Started:** 2026-11-10 · **Finished:** · **Effort estimate:** 15 to 25 focused hours (D-019)

## Goal
Everything Phase 3 needs before any Unity rover code is written: a working **ROS 2 development container** on the Mac, and a reviewed **rover dynamics spec** with test cases that Phase 3 implements first.

## Why it matters
- Phase 3 builds a 500 Hz rover with a ROS 2 bridge. Writing the model and its interface down first, with test cases, keeps that build small and checkable.
- For reviewers: a spec with units, frames, rates and test cases, plus a reproducible ROS 2 environment, shows simulation engineering discipline.

## Scope
**In**
- ROS 2 container in `infra/ros2/`: distro and macOS visualisation path chosen from current official docs (D-021); Dockerfile + compose; smoke test.
- `docs/specs/ROVER_DYNAMICS_SPEC.md`: state vector and frames (ENU world, FLU body, D-020); differential-drive / skid-steer kinematics and a wheel-slip model; parameters with units; integrator (D-016); controllers and rates (500 Hz wheel-speed inner loop, 50 Hz velocity/heading outer loop, pure-pursuit path following; D-004); determinism (D-017); ROS 2 interface (topics, message types, frame ids, rates); test cases.

**Stretch (first to cut)**
- A Python reference rover model implementing the spec, used later to cross-check the Unity implementation.
- A comparison with Gazebo's diff-drive model in the ROS 2 container.

**Out (deliberately)**
- Any Unity rover, sensor or bridge code (Phase 3).
- Drone dynamics (optional later phase, D-019).

## Deliverables
- `infra/ros2/` (Dockerfile, compose file, README with run instructions).
- `docs/specs/ROVER_DYNAMICS_SPEC.md`.
- D-021 updated with the chosen distro and viewer.
- `RETRO.md`; Phase 3 brief drafted.

## Exit criteria (checkable)
- [ ] `docker compose -f infra/ros2/compose.yaml up` starts the container; a talker/listener pair exchanges messages; a static + dynamic tf tree is visible in the chosen viewer
- [ ] D-021 records the ROS 2 distro and the macOS viewer path, with the doc links used
- [ ] `ROVER_DYNAMICS_SPEC.md` covers state, frames, models, parameters with units, integrator, controllers and rates, determinism and the ROS 2 interface, with numbered test cases and no TODOs
- [ ] Spec reviewed with `/code-review` (Spec axis) and findings resolved
- [ ] `RETRO.md` written; Phase 3 brief drafted (including the D-015 open items and the D-021 bridge choice)

## Risks and unknowns
| Risk | Mitigation |
|---|---|
| ROS 2 GUI tools on macOS | Run ROS 2 in a Linux container; choose VNC-based RViz or Foxglove from current docs; record gotchas in NOTES |
| Apple Silicon images for the chosen distro | Check arm64 image availability before choosing; fall back to building from the official base |
| Spec turns out wrong once implemented | Phase 3 starts by implementing the spec's test cases; spec revisions are logged |

## Demo to record at the end
Terminal + viewer recording: the container starting, a tf tree in the viewer, and the spec's test-case table.
