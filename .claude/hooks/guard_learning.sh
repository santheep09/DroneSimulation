#!/usr/bin/env bash
# PreToolUse (Edit|Write|NotebookEdit): in Learning mode the user writes the code.
# Blocks (exit 2) writes under learning/ except test files.
input=$(cat)
path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_input.notebook_path // empty')
[ -z "$path" ] && exit 0
root="${CLAUDE_PROJECT_DIR:-$PWD}"
case "$path" in /*) abs="$path" ;; *) abs="$root/$path" ;; esac
case "$abs" in
  "$root"/learning/*) ;;
  *) exit 0 ;;
esac
base=$(basename "$abs")
case "$abs" in */tests/*) exit 0 ;; esac
case "$base" in test_*.py|*_test.py) exit 0 ;; esac
echo "Learning mode: the user writes this. Give hints. (Only test files and docs/LEARNING_LOG.md are writable here.)" >&2
exit 2
