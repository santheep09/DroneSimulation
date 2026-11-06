#!/usr/bin/env bash
# SessionStart: orient the session (phase, next open tasks, git state).
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
tasks=$(ls docs/phases/*/TASKS.md 2>/dev/null | head -1)
if [ -n "$tasks" ]; then
  echo "Phase: $(basename "$(dirname "$tasks")")"
  echo "Next open tasks:"
  grep -E '^\s*- \[ \]' "$tasks" | head -5 | cut -c1-110
fi
echo "Git:"
git status -sb 2>/dev/null | head -10
exit 0
