# Glossary

Settled terms only. Add an entry when a term is fixed by a decision or used in a spec. Format: **Term**: definition. Convention or decision reference if one applies.

- **ENU**: world frame with x East, y North, z Up; right-handed. Climbing is positive z. The project's world frame (D-020).
- **FLU**: body frame fixed to the vehicle with x Forward, y Left, z Up; right-handed. The project's body frame (D-020).
- **REP 103**: the ROS standard for units (SI) and coordinate conventions (ENU world, FLU body). Followed so ROS 2 messages need no conversion (D-020, D-021).
- **NED**: x North, y East, z Down; climbing is negative z. Common in aviation; was the project frame until D-020 replaced it.
- **SIL (software-in-the-loop)**: the autonomy software runs as separate programs (here ROS 2 nodes) and drives the simulated vehicle in a closed loop, as it would drive the real one.
