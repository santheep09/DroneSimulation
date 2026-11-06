# Search-and-Rescue Drone Simulator

A Unity 6 quadrotor simulator: a drone searches procedurally generated biomes (dunes, rocky wadis, urban blocks, mangroves) for people and vehicles. One physically grounded sim core (SI/NED, 500 Hz, cascaded control) feeds:

1. **Synthetic aerial dataset + detector**, with the sim-to-real gap measured
2. **RL search policy** (Unity ML-Agents), 5 seeds, train 3 biomes / test the 4th
3. **Agent evaluation harness**: VLM-commanded missions scored on success, safety and cost

> 🚧 Phase 1 (Foundation) in progress. See [docs/00_MASTER_PLAN.md](docs/00_MASTER_PLAN.md).

## Docs
- [Master plan](docs/00_MASTER_PLAN.md) · [Problem statement](docs/PROBLEM_STATEMENT.md) · [Decisions](docs/DECISIONS.md) · [Workflow](docs/WORKFLOW.md)
- [Phase 1 brief](docs/phases/Phase1_Foundation/BRIEF.md)

## Setup
Machine setup: [docs/SETUP.md](docs/SETUP.md). Check with `bash infra/setup_check.sh`.
