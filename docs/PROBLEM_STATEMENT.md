# Problem Statement: Search-and-Rescue Drone Simulator

## Problem
Search-and-rescue drones need to find people and vehicles across very different terrain: desert dunes, rocky wadis, dense urban blocks, coastal mangroves. Training their perception and search behaviour on real flights is slow, expensive and dangerous, and real data rarely covers every biome, lighting condition and target pose. Testing autonomy, including language-commanded agents, needs scenarios you can repeat exactly, with safety measured.

## Solution
A Unity 6 simulator with **one physically grounded sim core** (quadrotor dynamics in SI units, NED frame, 500 Hz physics, cascaded control) over **procedurally generated biomes**, feeding three outputs:

1. **Synthetic aerial dataset + detector.** Custom label capture (segmentation, 2D boxes, COCO export); detector trained on synthetic data; sim-to-real gap measured on a held-out biome and on real images.
2. **RL search policy** (ML-Agents 4.x). Waypoint navigation, then coverage search; benchmarked on steps/sec, determinism and 5 seeds; trained on 3 biomes, tested on the 4th.
3. **Agent evaluation harness.** A vision-language model issues mission commands; runs are scored on success, safety violations and cost; leaderboard.

## Who it's for
AI and robotics teams who need training data, RL environments and evaluation for aerial autonomy. Portfolio angle: shows I can build the world, the data pipeline, the training environment and the evals. That's the full job of a simulation, synthetic-data, RL-environment or evaluation engineer.

## Out of scope
Real hardware and flight controllers (PX4/ArduPilot), multi-drone swarms, photoreal city-scale worlds.
