# Search-and-Rescue Rover Simulator

A Unity 6 ground-vehicle simulator: a skid-steer rover searches procedurally generated biomes (dunes, rocky wadis, urban blocks, mangroves) for people and vehicles. One physically grounded, deterministic sim core (SI units, ENU/FLU frames per ROS REP 103, 500 Hz, cascaded control) with ROS 2 as its interface feeds:

1. **Validation pipeline**: scenarios scored on success, safety and cost; ROS 2 software-in-the-loop and VLM agents; headless runs in CI
2. **Synthetic dataset + detector**, with the sim-to-real gap measured
3. **RL search policy** (Unity ML-Agents), 5 seeds, train 3 biomes / test the 4th

> 🚧 Phase 2 (Rover design + ROS 2 dev environment) in progress. See [docs/00_MASTER_PLAN.md](docs/00_MASTER_PLAN.md).

## Docs
- [Master plan](docs/00_MASTER_PLAN.md) · [Problem statement](docs/PROBLEM_STATEMENT.md) · [Decisions](docs/DECISIONS.md) · [Workflow](docs/WORKFLOW.md)
- [Phase 2 brief](docs/phases/Phase2_RoverDesign/BRIEF.md)

## Setup
Machine setup: [docs/SETUP.md](docs/SETUP.md). Check with `bash infra/setup_check.sh`.
