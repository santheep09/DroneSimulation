#!/usr/bin/env bash
# Rover Simulator: read-only setup check for macOS.
# Installs nothing, changes nothing. Run:  bash infra/setup_check.sh
# Paste the full output back to Claude.

ok()   { printf "  [OK]      %-22s %s\n" "$1" "$2"; }
miss() { printf "  [MISSING] %-22s %s\n" "$1" "$2"; }
warn() { printf "  [CHECK]   %-22s %s\n" "$1" "$2"; }
have() { command -v "$1" >/dev/null 2>&1; }

echo "== System =="
ok "macOS" "$(sw_vers -productVersion 2>/dev/null) ($(uname -m))"
ok "Chip" "$(sysctl -n machdep.cpu.brand_string 2>/dev/null)"
ok "Memory" "$(( $(sysctl -n hw.memsize 2>/dev/null) / 1073741824 )) GB"
ok "Free disk (/)" "$(df -h / | awk 'NR==2{print $4}')"
ok "Shell" "$SHELL"

echo "== Base tools =="
if xcode-select -p >/dev/null 2>&1; then ok "Xcode CLT" "$(xcode-select -p)"; else miss "Xcode CLT" "run: xcode-select --install"; fi
if have brew; then ok "Homebrew" "$(brew --version | head -1)"; else miss "Homebrew" "see docs/SETUP.md step 2"; fi
if have git; then ok "git" "$(git --version) at $(command -v git)"; else miss "git" ""; fi
if have git-lfs; then ok "git-lfs" "$(git lfs version | head -1)"; else miss "git-lfs" "brew install git-lfs"; fi
n="$(git config --global user.name 2>/dev/null)"; e="$(git config --global user.email 2>/dev/null)"
if [ -n "$n" ] && [ -n "$e" ]; then ok "git identity" "$n <$e>"; else miss "git identity" "git config --global user.name/user.email"; fi
if have gh; then
  if gh auth status >/dev/null 2>&1; then ok "GitHub CLI" "$(gh --version | head -1), logged in"; else warn "GitHub CLI" "installed, NOT logged in: gh auth login"; fi
else miss "GitHub CLI" "brew install gh"; fi
if have node; then ok "Node (optional)" "$(node --version)"; else ok "Node (optional)" "not installed, not needed"; fi

echo "== Python =="
if have uv; then ok "uv" "$(uv --version)"; else miss "uv" "brew install uv"; fi
if have python3; then ok "python3 (system)" "$(python3 --version 2>&1) at $(command -v python3)"; else warn "python3" "none on PATH (fine if using uv)"; fi
if have uv; then
  pys="$(uv python list --only-installed 2>/dev/null | awk '{print $1}' | tr '\n' ' ')"
  case "$pys" in *3.10.12*) ok "uv Python 3.10.12" "present (ML-Agents)";; *) miss "uv Python 3.10.12" "uv python install 3.10.12";; esac
  case "$pys" in *3.12*) ok "uv Python 3.12" "present (main ML)";; *) miss "uv Python 3.12" "uv python install 3.12";; esac
fi
# Project envs (read-only: --frozen --no-sync never installs or edits the lock)
here_py="$(cd "$(dirname "$0")/.." && pwd)"
if have uv; then
  if [ -f "$here_py/ml/uv.lock" ]; then
    out="$(cd "$here_py/ml" && uv run --frozen --no-sync python -c "import sys, torch; print(sys.version.split()[0], 'torch', torch.__version__, 'mps', torch.backends.mps.is_available())" 2>&1 | tail -1)"
    case "$out" in *"mps True"*) ok "ml/ env" "$out";; *"torch"*) warn "ml/ env" "$out (MPS not available)";; *) miss "ml/ env" "cd ml && uv sync";; esac
  else miss "ml/ env" "ml/uv.lock not found (TASKS 1.6)"; fi
  if [ -f "$here_py/rl/uv.lock" ]; then
    out="$(cd "$here_py/rl" && uv run --frozen --no-sync python -W ignore -c "import sys, torch; from importlib.metadata import version; print(sys.version.split()[0], 'torch', torch.__version__, 'mlagents', version('mlagents'))" 2>&1 | tail -1)"
    case "$out" in 3.10.12*mlagents*) ok "rl/ env" "$out";; *) miss "rl/ env" "cd rl && uv sync";; esac
    if (cd "$here_py/rl" && uv run --frozen --no-sync mlagents-learn --help >/dev/null 2>&1); then ok "mlagents-learn" "--help works"; else miss "mlagents-learn" "cd rl && uv sync"; fi
  else miss "rl/ env" "rl/uv.lock not found (TASKS 1.6)"; fi
fi
if have conda; then warn "conda" "found ($(conda --version)); we use uv, so keep conda out of this project"; fi

echo "== Unity =="
if [ -d "/Applications/Unity Hub.app" ]; then ok "Unity Hub" "installed"; else miss "Unity Hub" "brew install --cask unity-hub"; fi
eds=""
for d in /Applications/Unity/Hub/Editor/*/; do [ -d "$d" ] && eds="$eds $(basename "$d")"; done
UNITY_PIN="6000.6.2f1"   # D-013
if [ -n "$eds" ]; then ok "Unity editors" "$eds"; else miss "Unity editors" "install Unity $UNITY_PIN via Hub"; fi
case "$eds" in *"$UNITY_PIN"*) ok "Unity (pinned)" "$UNITY_PIN present";; *) miss "Unity (pinned)" "$UNITY_PIN via Unity Hub > Installs";; esac
if [ -d "$HOME/.unity/relay" ]; then ok "Unity MCP relay" "$HOME/.unity/relay"; else ok "Unity MCP relay" "not yet (appears after Phase 1 task 1.7)"; fi

echo "== IDE / Claude =="
r="$(ls -d /Applications/Rider*.app "$HOME/Applications/Rider"*.app 2>/dev/null | head -1)"
if [ -n "$r" ]; then ok "JetBrains Rider" "$r"; else miss "JetBrains Rider" "via JetBrains Toolbox"; fi
if have claude; then ok "Claude Code CLI" "$(claude --version 2>/dev/null)"; else miss "Claude Code CLI" "curl -fsSL https://claude.ai/install.sh | bash"; fi
if [ -d "/Applications/Claude.app" ]; then ok "Claude desktop app" "installed"; else warn "Claude desktop app" "not found (optional)"; fi

echo "== Project folder =="
here="$(cd "$(dirname "$0")/.." && pwd)"
ok "Project root" "$here"
if [ -d "$here/.git" ]; then ok "git repo" "yes"; else miss "git repo" "not yet (Phase 1 task 1.3)"; fi
echo "Done."
