# Search-and-Rescue Rover Simulator: Master Plan

**Plan v4:** 2026-11-11 (D-019 to D-022; builds on v3 of 2026-11-10, D-015) · **Current:** Phase 2 (Rover design + ROS 2 dev environment)

---

## 1. Goal
Build the portfolio in **Unity 6**: a modular simulation platform for autonomous ground vehicles, with ROS 2 integration, a validation pipeline in CI and measured results. Optional extensions (lunar biome, cross-simulator comparison, drone) gate nothing (D-019).

## 2. The project: search-and-rescue rover simulator
A 4-wheel skid-steer rover searches procedurally generated terrain (**dunes, rocky wadis, urban blocks, mangroves**) for people and vehicles. One sim core feeds three outputs, and they are **one system**: a mission API and a validation pipeline, with every other artefact an agent scored on its leaderboard.

1. **Validation pipeline (the spine).** Scenario suite, scripted baselines, a ROS 2 software-in-the-loop (SIL) agent, a VLM-issued command agent; score success, safety violations and cost with confidence intervals; runs headless in CI.
2. **Synthetic dataset + object detector.** Sim-to-real gap measured on a held-out biome and on real images.
3. **RL search policy** with ML-Agents 4.x. Benchmarks: steps/sec, determinism, 5 seeds; train on 3 biomes / test on the 4th (stretch).

Full problem statement: [`PROBLEM_STATEMENT.md`](PROBLEM_STATEMENT.md). Decisions: [`DECISIONS.md`](DECISIONS.md). How phases run: [`WORKFLOW.md`](WORKFLOW.md).

## 3. Principles (D-015)
1. **Vertical slices.** Every phase ends with something runnable and publishable.
2. **Design before build.** Each build phase starts from a written spec with test cases.
3. **Evaluation is the spine.** The mission API and leaderboard exist early.
4. **Cut before slipping.** Each phase has a must-have and a stretch; stretch drops first.
5. **Publish at every phase.** Short write-up with numbers, plus a GIF or video.

## 4. Phases
Phases are **gated by exit criteria**, not by the calendar (D-010). Effort is focused hours of project work, an estimate; recalibrate after Phase 2.

| Phase | Name | Effort (h) | Must-have | Stretch | Publish |
|---|---|---|---|---|---|
| 1 | Foundation: Claude Code setup, repo, Unity MCP | done | Working agent workflow | | |
| 2 | **Rover design + ROS 2 dev environment** | 15–25 | ROS 2 container in `infra/ros2/` (distro and macOS viewer chosen, D-021), rover dynamics spec with test cases (`docs/specs/ROVER_DYNAMICS_SPEC.md`) | Python reference rover model; Gazebo diff-drive comparison | Spec + container |
| 3 | **Sim core + ROS 2 bridge + mission API v0** | 100–130 | Custom integrator (D-016), rover with terrain contact, cascaded controller, determinism tests (D-017), one biome, camera + IMU + wheel odometry + GPS with noise models, ROS 2 bridge, headless Linux build in Docker, mission API, scripted baselines, ML-Agents handshake smoke test | Second biome | **#1** Seeded mission over ROS 2, bit-identical replay |
| 4 | **Validation pipeline** | 60–80 | Scenario files, scoring (success, safety, cost), baselines, ROS 2 SIL agent, VLM-agent adapter, results with CIs, CI on GitHub Actions in Docker, 2–3 biomes | Leaderboard page; real-to-sim fit against a public rover log | **#2** First validation results |
| 5 | **Perception** | 90–120 | Headless capture, COCO export, domain randomisation, detector, mAP on synthetic / held-out biome / real images | Lidar sensor; detector as a tool for the VLM agent | **#3** Sim-to-real gap |
| 6 | **RL**, time-boxed | 80–110 | Action space and rate fixed (D-018: velocity setpoints for the rover), waypoint navigation, 5 seeds, steps/sec, policy on the leaderboard | Coverage search; train 3 / test 4th biome | **#4** RL on the leaderboard (a negative result is publishable) |
| 7 | **Polish and showcase** | 25–35 | README, user guide, demo video, final leaderboard, limitations section | | **#5** Capstone write-up |
| Optional | Lunar biome → cross-sim comparison (CARLA or Gazebo) → drone as a second vehicle | | In that priority, only after Phase 7 | | |

**Cut order:** drone → cross-sim comparison → lunar biome → coverage search and 3-train/1-test RL → fourth biome → detector-as-tool → real-to-sim fit.

**Why this order:** the rover is the gentler first vehicle and the closest match to off-road autonomy work. The validation pipeline needs only the sim core, ROS 2 and a hosted VLM, so it comes before perception and RL. Perception is simpler and deterministic. RL is the riskiest, so it goes last among the heavy phases and is time-boxed.

## 5. Phase 2 detail (rover design + ROS 2 dev environment)
- **ROS 2 container** (`infra/ros2/`): distro and macOS visualisation path chosen from current docs (D-021); compose file; smoke test with a talker/listener and a tf tree.
- **Rover dynamics spec** (`docs/specs/ROVER_DYNAMICS_SPEC.md`): state and frames (ENU/FLU, D-020); differential-drive / skid-steer kinematics and wheel-slip model; parameters with units; integrator choice (D-016); controllers and rates (500 Hz wheel-speed inner loop, 50 Hz outer loop, pure pursuit; D-004); determinism (D-017); ROS 2 interface (topics, frames, rates); test cases Phase 3 implements first.
- Stretch: a Python reference rover model (to cross-check the Unity implementation) and a comparison with Gazebo's diff-drive.

## 6. Ramp-up before Phases 5 and 6
Phases 5 and 6 start with a short ramp-up on the concepts they use (detection metrics such as IoU, NMS and mAP; PPO and RL training practice). The ramp-up material itself is kept outside this repo (D-022); only project code and results land here.

## 7. Definition of done
- Public GitHub repo, reproducible setup, README with GIFs
- Publishes #1 to #5, each with a write-up and results backed by numbers (seeds, confidence intervals)
- ROS 2 interface documented; CI runs the scenario suite headless in Docker
- Demo video; limitations section stating that Unity is a non-standard stack for this domain and why it was chosen (D-001, D-008)

## 8. Setup facts
- Machines: Apple Silicon Mac now; a Windows machine with a CUDA GPU later (optional extensions, possible heavier training)
- Tools: Rider, git + GitHub, Docker, Claude Code
