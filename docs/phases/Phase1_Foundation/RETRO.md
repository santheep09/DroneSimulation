# Phase 1 Retro: Foundation

## Outcome
Tasks 1.1 to 1.9 are done and verified. The final exit-criteria check (2026-11-09) found nothing failing. The demo is `media/demo.md` (text output; the screen recording failed). Open: this retro's sign-off and the Phase 2 brief (claude.ai), then tick 1.10.

## What worked
- **Tests first, even for config.** The timestep test failed at Unity's 0.02 default, then passed at 0.002 (D-004). The headless runner caught a real project setting.
- **Headless Unity.** `infra/unity_test.sh` gives a pass/fail exit code and an XML result with no Editor open. Licence activation worked in batchmode.
- **Hooks as guarantees.** The privacy guard (hook plus pre-commit and commit-msg) stopped personal text from reaching the repo, CLAUDE.md alone would only have been a request.
- **Parallel sessions on disjoint files.** 1.6 (Python envs) and 1.9c to e (rules, skills, subagents) ran side by side without conflicts.
- **Looking up current docs.** Unity MCP and ML-Agents versions had changed since the plan was written (D-005, D-011, D-012 were all corrected).

## What slipped or went wrong
- **Personal background text was committed in a public repo's CLAUDE.md.** Fix: scrubbed, history squashed, repo recreated, private context moved to gitignored files, guard added. Lesson: the guard should have existed before the first commit.
- **Repo visibility was changed without being asked.** It was made private when the user wanted it public. Lesson: state the plan before any change that is outward-facing or hard to reverse.
- **Unity Hub created a nested git repo and a second GitHub repo.** Both removed. Lesson: record the "leave git off" Hub setting in the task steps.
- **Folder name drifted from the plan (`sim/` to `DroneSim/`)**, which needed a rename pass across docs and ignore rules (D-014).
- **Privacy guard false positives.** It blocks any Bash command containing the home path, and it silently does nothing when `.private/patterns.txt` is missing (as in a worktree).
- **Auto-mode classifier blocked a compound command** that included `git checkout`. Splitting the command worked.
- **Button wording** ("Project created") read as a claim by the user rather than a choice.

## Decisions changed or added
- D-005: ML-Agents Unity package 4.1.0 with PyPI `mlagents` 1.1.0.
- D-011: Accepted. `ml/` on Python 3.12, `rl/` on Python 3.10.12 with `grpcio` and `setuptools` workarounds.
- D-012: Accepted. Unity MCP uses the user-scope `unity-mcp` server; console reads allowed, `RunCommand` and captures ask, `GenerateAsset` denied.
- D-013: Unity pinned to 6000.6.2f1.
- D-014: Unity project folder is `DroneSim/`.
- D-006: details moved out of the repo.

## Open improvements (not yet done)
1. Make the hooks find `.private/` from worktrees (`git rev-parse --git-common-dir`), so the privacy guard cannot silently no-op.
2. Strip the home path from Bash commands before the privacy guard matches.
3. A commit-msg hook that requires the `N.N:` task id prefix.
4. Fewer confirmation boxes for trivial steps.
5. Unity MCP cannot enforce read-only for `RunCommand`; the Unity-side Allow/Revoke approval and the ask rule are the only controls.
6. The macOS notification hook in the user-level settings is still unanswered.
7. Template tutorial assets (`Readme.asset`, `TutorialInfo/`) remain in `RoverSim/` (was `DroneSim/`, D-023).

## Carry into Phase 2
- The foundations Phase 2 builds on are in place: SI units (frames later moved to ENU/FLU, D-020), 500 Hz step, the test loop and the `ml/` env.
- The real Unity-to-Python ML-Agents handshake is untested until the Phase 3 handshake smoke test.
- Phase 2 (plan v4) is the rover design + ROS 2 dev environment.
