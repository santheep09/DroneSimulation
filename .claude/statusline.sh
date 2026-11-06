#!/usr/bin/env bash
# Status line: model | context used % | git branch. Reads Claude Code JSON on stdin.
input=$(cat)
model=$(printf '%s' "$input" | jq -r '.model.display_name // "?"')
used=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')
dir=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty')

if [ -n "$used" ]; then
  ctx=$(printf 'ctx %.0f%%' "$used")
else
  ctx="ctx --"
fi

branch=""
if [ -n "$dir" ] && [ -d "$dir" ]; then
  branch=$(git -C "$dir" --no-optional-locks symbolic-ref --short -q HEAD 2>/dev/null \
    || git -C "$dir" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
fi

out="$model | $ctx"
[ -n "$branch" ] && out="$out | $branch"
printf '%s\n' "$out"
