# Problem Statement: Search-and-Rescue Rover Simulator

## Problem
Search-and-rescue ground robots need to find people and vehicles across very different terrain: desert dunes, rocky wadis, dense urban blocks, coastal mangroves. Developing and validating their autonomy on real vehicles is slow, expensive and risky, and real data rarely covers every terrain, lighting condition and target pose. Testing autonomy software, including language-commanded agents, needs scenarios you can repeat exactly, with safety measured, run automatically on every change.

## Solution
A Unity 6 simulator with **one physically grounded sim core** (rover dynamics in SI units, ENU/FLU frames per ROS REP 103, 500 Hz physics, cascaded control, deterministic from a seed) over **procedurally generated biomes**, with **ROS 2 as the external interface** (D-019 to D-021). It feeds three outputs:

1. **Validation pipeline.** Scenario files, scripted baselines, a ROS 2 software-in-the-loop agent and a vision-language-model agent that issues mission commands; runs are scored on success, safety violations and cost; headless runs in CI; leaderboard.
2. **Synthetic dataset + detector.** Custom label capture (segmentation, 2D boxes, COCO export); detector trained on synthetic data; sim-to-real gap measured on a held-out biome and on real images.
3. **RL search policy** (ML-Agents 4.x). Waypoint navigation, then coverage search; benchmarked on steps/sec, determinism and 5 seeds; trained on 3 biomes, tested on the 4th.

## Who it's for
Robotics and AI teams who need simulation, sensor models, training data, RL environments and validation for ground autonomy. Portfolio angle: shows the whole job of a simulation, synthetic-data, RL-environment or evaluation engineer: the world, the vehicle and sensor models, the ROS 2 integration, the data pipeline, the training environment and the evals.

## Out of scope
Real hardware and hardware-in-the-loop, multi-robot fleets, photoreal city-scale worlds. Optional later: a lunar biome, a cross-simulator comparison (CARLA or Gazebo), a drone as a second vehicle (D-019).
