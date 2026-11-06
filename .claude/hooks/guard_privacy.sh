#!/usr/bin/env bash
# PreToolUse (Edit|Write|NotebookEdit|Bash): never write personal details into tracked files
# or commit messages. Patterns live in .private/patterns.txt (gitignored, local only).
root="${CLAUDE_PROJECT_DIR:-$PWD}"
pat="$root/.private/patterns.txt"
[ -f "$pat" ] || exit 0
input=$(cat)
path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_input.notebook_path // empty')
case "$path" in */.private/*|*/CLAUDE.local.md) exit 0 ;; esac
text=$(printf '%s' "$input" | jq -r '[.tool_input.new_string, .tool_input.content, .tool_input.new_source, .tool_input.command] | map(select(. != null)) | join("\n")')
# Bash commands that deliberately target the private files are allowed.
case "$text" in *".private/"*|*"CLAUDE.local.md"*) [ -n "$path" ] || exit 0 ;; esac
hit=$(printf '%s' "$text" | grep -Eio -f "$pat" | head -3 | paste -sd, -)
[ -z "$hit" ] && exit 0
echo "Privacy guard: personal detail detected ($hit). Never put personal context in tracked files or commit messages. Keep it in CLAUDE.local.md or .private/ (gitignored). Rephrase generically." >&2
exit 2
