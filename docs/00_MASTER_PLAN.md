# Drone Simulator: Master Plan

**Plan v2:** 2026-11-05 (built from `HANDOFF_PROMPT.md`, 2026-10-07; weeks renamed to phases) · **Current:** Phase 1 (Foundation), not started

---

## 1. Goal
Build the portfolio in **Unity 6** first, then port part of it to **Unreal**.

## 2. The project: search-and-rescue drone simulator
A quadrotor searches procedurally generated terrain (**dunes, rocky wadis, urban blocks, mangroves**) for people and vehicles. One sim core feeds three portfolio pieces:

1. **Synthetic aerial dataset + object detector.** Sim-to-real gap measured on held-out data.
2. **RL search policy** with ML-Agents 4.x. Benchmarks: steps/sec, determinism, 5 seeds, train on 3 biomes / test on the 4th.
3. **Agent evaluation harness.** A vision-language model gives mission commands; score success, safety violations and cost.

Full problem statement: [`PROBLEM_STATEMENT.md`](PROBLEM_STATEMENT.md). Decisions: [`DECISIONS.md`](DECISIONS.md). How phases run: [`WORKFLOW.md`](WORKFLOW.md).

## 3. Phases

Phases are **gated by exit criteria**, not by the calendar. The week numbers are only a guide.

| Phase | Name | Guide (weeks) | Output | Gate to exit |
|---|---|---|---|---|
| **1** | **Foundation: Claude Code setup, repo, Unity MCP** | 1 | Working agent workflow | Phase 1 exit criteria in [BRIEF](phases/Phase1_Foundation/BRIEF.md) |
| 2 | Fundamentals, hand-written by me (ML basics, RL mechanics, quadrotor physics) | 2–4 | Private learning log | **Harder diagnostic: 8/10** before starting the sim core |
| 3 | Sim core: dynamics, controller, sensors, terrain, determinism tests | 5–7 | **Publish #1** | Determinism tests green; dynamics match the spec from Phase 2 |
| 4 | Perception: synthetic dataset, detector, held-out biome + real images | 8–10 | **Publish #2** | mAP reported on synthetic, held-out biome, and real images |
| 5 | RL: waypoint navigation → coverage search | 11–13 | **Publish #3** | 5-seed results, train 3 biomes / test the 4th, steps/sec benchmark |
| 6 | Agent eval harness + leaderboard | 14–16 | **Publish #4** | VLM-commanded missions scored on success, safety, cost |
| 7 | Unreal port on a Windows machine | 17+ | Cross-engine comparison | |

## 4. Phase 2 detail (the fundamentals: you write the code, Claude teaches)

**2a: ML (guide week 2)**
- Polynomial overfitting + train/val/test splits
- Hand-written PyTorch training loop (remove `zero_grad` and see what happens)
- FashionMNIST CNN on MPS
- IoU + NMS by hand (Claude writes the tests)
- Fine-tune a torchvision detector + mAP

**2b: RL (guide week 3)**
- RL vocabulary + random CartPole agent
- SB3 PPO on CartPole over 5 seeds
- PPO clip-range experiment
- ML-Agents 3DBall in Unity 6
- My own tiny env with a deliberate reward hack

**2c: Drones (guide week 4)**
- Mixer matrix + yaw (reaction torque between rotor pairs, not a tail rotor)
- NED/ENU/Unity frame conversions (Claude writes the sign and round-trip tests)
- 1D altitude PID
- 2D quadrotor with 500 Hz inner / 50 Hz outer loop, then slow the inner loop to see instability
- Compare against an open-source reference quad sim
- Write the spec for the Unity dynamics module

**Gate:** harder diagnostic at the end; need 8/10 before Phase 3.

## 5. Where I'm starting from (diagnostic, 10 questions)
- **Correct:** reward hacking, why RL uses multiple seeds.
- **Don't know yet:** overfitting, train/val/test discipline, IoU, PPO clipping, cascaded loop rates, `optimizer.zero_grad()`.
- **Confidently wrong, now corrected:** quadrotors yaw via reaction torque between rotor pairs (no tail rotor); in NED, climbing is **negative z** (z points down).

→ ML, RL mechanics and drone physics are **learning-mode** topics: Claude teaches and reviews, I write the code. See `CLAUDE.md`.

## 6. Definition of done
- Public GitHub repo, reproducible setup, README with GIFs
- Four publishable pieces (Phases 3–6), each with a write-up and results backed by numbers
- Demo video; cross-engine comparison (Phase 7)

## 7. Setup facts
- Machines: Apple Silicon Mac now; a Windows machine with a CUDA GPU later (Unreal port)
- Tools: Rider, git + GitHub, Claude Code
