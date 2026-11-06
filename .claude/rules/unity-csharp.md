---
paths:
  - "DroneSim/**/*.cs"
---
# Unity C# rules

- Namespace `DroneSim.*`. PascalCase types and methods, `_camelCase` private fields.
- One MonoBehaviour per file; file name equals class name.
- Dynamics code uses SI units and the NED frame (climbing is negative z). NED/SI types never touch `Transform` outside the single boundary class that converts to Unity axes.
- Physics runs at a fixed 500 Hz step (`Time.fixedDeltaTime = 0.002`). Dynamics and control live in `FixedUpdate`, never `Update`.
- No heap allocations in `FixedUpdate` or other per-step paths: no LINQ, `new` of reference types, string building, or boxing; preallocate and reuse.
- Determinism: all randomness comes from an explicitly seeded RNG passed in (never `UnityEngine.Random` global state, `System.Random()` without a seed, or wall-clock time).
- Tests: EditMode tests live in the test assembly; keep them runnable headless via `infra/unity_test.sh`.
- Never commit generated folders (`Library`, `Temp`, `Logs`, `UserSettings`, `Builds`).
