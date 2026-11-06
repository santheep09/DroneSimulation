#!/usr/bin/env bash
# PostToolUse (Edit|Write): ruff format + check on edited Python files in ml/ or rl/.
input=$(cat)
path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')
case "$path" in *.py) ;; *) exit 0 ;; esac
root="${CLAUDE_PROJECT_DIR:-$PWD}"
case "$path" in
  "$root"/ml/*) proj="$root/ml" ;;
  "$root"/rl/*) proj="$root/rl" ;;
  *) exit 0 ;;
esac
[ -f "$proj/pyproject.toml" ] || exit 0
cd "$proj" || exit 0
uv run ruff format "$path" >/dev/null 2>&1
out=$(uv run ruff check "$path" 2>&1) || { printf '%s\n' "$out" >&2; exit 2; }
exit 0
