# Phase 1 demo (command output)

Captured 2026-11-09 by Claude Code. Home directory replaced with `~`; hardware, disk and git-identity lines removed.

## `infra/setup_check.sh`
```
== System ==
  [OK]      macOS                  27.0 (arm64)
  [OK]      Shell                  /bin/zsh
== Base tools ==
  [OK]      Xcode CLT              /Library/Developer/CommandLineTools
  [OK]      Homebrew               Homebrew 7.0.12
  [OK]      git                    git version 2.54.0 (Apple Git-157) at /usr/bin/git
  [OK]      git-lfs                git-lfs/3.8.1 (GitHub; darwin arm64; go 1.27.3)
  [OK]      GitHub CLI             gh version 2.103.3 (2026-10-26), logged in
  [OK]      Node (optional)        not installed, not needed
== Python ==
  [OK]      uv                     uv 0.13.7 (Homebrew 2026-11-03 aarch64-apple-darwin)
  [OK]      python3 (system)       Python 3.9.6 at /usr/bin/python3
  [OK]      uv Python 3.10.12      present (ML-Agents)
  [OK]      uv Python 3.12         present (main ML)
  [OK]      ml/ env                3.12.16 torch 2.15.0 mps True
  [OK]      rl/ env                3.10.12 torch 2.2.2 mlagents 1.1.0
  [OK]      mlagents-learn         --help works
== Unity ==
  [OK]      Unity Hub              installed
  [OK]      Unity editors           6000.6.2f1
  [OK]      Unity (pinned)         6000.6.2f1 present
  [OK]      Unity MCP relay        ~/.unity/relay
== IDE / Claude ==
  [OK]      JetBrains Rider        /Applications/Rider.app
  [OK]      Claude Code CLI        2.1.311 (Claude Code)
  [OK]      Claude desktop app     installed
== Project folder ==
  [OK]      Project root           ~/ClaudeWorkspace/SimulationProjects/DroneSimulation
  [OK]      git repo               yes
Done.
```

## `infra/unity_test.sh`
```
Running EditMode tests (Unity 6000.6.2f1)...
total=2 passed=2 failed=0 skipped=0
exit code: 0
```

## Editor menu `DroneSim/Environment Info` (Console output, pasted by the user)
```
Unity 6000.6.2f1 | fixed timestep 0.002 s (500 Hz) | render pipeline UniversalRenderPipelineAsset
```
