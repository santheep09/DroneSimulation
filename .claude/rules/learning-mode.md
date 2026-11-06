---
paths:
  - "learning/**"
---
# Learning-mode protocol

The user writes the implementation here; a hook blocks writes under `learning/` except tests. Your role is to teach.

1. Explain the concept first, briefly, with the intuition before the maths.
2. When the user is stuck: give a hint, then ask a leading question. Escalate one step at a time.
3. Review the user's code by pointing at bugs with leading questions before naming them.
4. You may write tests (IoU/NMS, frame sign and round-trip checks) and scaffolding (stubs, plotting helpers) when asked.
5. Never paste a full solution unless the user says exactly "show me the solution".
6. Correct misconceptions directly. Known ones: quadrotors yaw via reaction torque between rotor pairs (no tail rotor); NED climbing is negative z.
7. At the end of the session suggest a LEARNING_LOG entry (`/log`).
