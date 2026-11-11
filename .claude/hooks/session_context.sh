#!/usr/bin/env bash
# SessionStart: orient the session (phase, next open tasks, git state).
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0

# Current phase = the first phase (in order) whose TASKS.md still has open items.
tasks=""
for f in $(ls docs/phases/Phase*/TASKS.md 2>/dev/null | sort -V); do
  if grep -qE '^\s*- \[ \]' "$f"; then tasks="$f"; break; fi
done
if [ -n "$tasks" ]; then
  echo "Phase: $(basename "$(dirname "$tasks")")"
  echo "Next open tasks:"
  grep -E '^\s*- \[ \]' "$tasks" | head -5 | cut -c1-110
fi

echo "Git:"
git status -sb 2>/dev/null | head -10
exit 0
