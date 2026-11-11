# Machine Setup: before starting Claude Code

Goal: every tool installed and checked on the Apple Silicon Mac, so Phase 1 in Claude Code starts with project work, not installs.

**What happens here vs in Claude Code:** this guide installs **tools**. Creating the git repo, the Unity project and the Python environments, and connecting Unity MCP, are Phase 1 tasks done *with* Claude Code (TASKS 1.3–1.7). They depend on the repo.

Run the check first, install whatever it lists as missing (in this order), then run the check again.

---

## Step 0: Run the check (read-only)
```bash
cd ~/ClaudeWorkspace/SimulationProjects/RoverSimulation
bash infra/setup_check.sh
```
Paste the output into the claude.ai chat. Anything marked `[MISSING]` maps to a step below.

## Step 1: Xcode Command Line Tools
Gives you compilers, plus Apple's git, which Homebrew and Python builds need.
```bash
xcode-select --install
```
Skip if the check shows `[OK] Xcode CLT`.

## Step 2: Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# then follow the printed "Next steps" to add brew to your PATH (Apple Silicon: /opt/homebrew)
brew --version
```

## Step 3: git, Git LFS, identity
```bash
brew install git git-lfs
git lfs install                      # once per machine
git config --global user.name  "Your Name"
git config --global user.email "<the email you use on GitHub>"
git config --global init.defaultBranch main
```
Use your GitHub email (or GitHub's noreply address) so commits link to your profile.

## Step 4: GitHub account + CLI
1. Make sure you have a GitHub account for the portfolio (a personal one, not a work one).
2. Install the CLI and log in:
```bash
brew install gh
gh auth login        # GitHub.com → HTTPS → "Login with a web browser"
gh auth status
```
Don't create the repo yet. That's TASKS 1.3.

## Step 5: uv + both Python versions
The project needs **two** Python environments (see DECISIONS D-011):
- **Main ML env** (Phase 2a, Phase 4): Python 3.12 + current PyTorch with MPS.
- **ML-Agents env** (Phase 2b, Phase 5): **Python 3.10.12** + PyTorch ~2.2 + `mlagents`. That's what the ML-Agents 4.x docs require.

```bash
brew install uv
uv python install 3.12 3.10.12
uv python list --only-installed
```
uv manages Python itself, so you don't need conda or pyenv. If you already have conda, leave it alone, just don't use it for this project.

## Step 6: Unity Hub + Unity 6.6 (6000.6.2f1, pinned, D-013)
```bash
brew install --cask unity-hub
```
1. Open Unity Hub → sign in with your Unity ID → **Preferences → Licenses**: make sure a Personal (or your own) licence is active. The headless test runner (TASKS 1.5) also needs an active licence.
2. **Installs**: Unity **6000.6.2f1** (Apple silicon). Don't upgrade it during a phase. Upgrades happen only at phase boundaries, as a decision-log entry.
3. Modules: none needed now (Mac build support is included).
4. **Don't create the project yet.** That's TASKS 1.4, with Claude Code giving the exact settings.

## Step 7: Rider for Unity
You already use Rider. Check:
- It's up to date (JetBrains Toolbox), and the **Unity Support** plugin is enabled (bundled by default).
- Setting Rider as Unity's external editor happens in TASKS 1.4, once the project exists.

## Step 8: Claude Code
```bash
curl -fsSL https://claude.ai/install.sh | bash
# open a NEW terminal window, then:
claude --version
claude doctor
```
- The native installer is recommended. It auto-updates; Homebrew (`brew install --cask claude-code`) does not.
- Log in: run `claude` once and follow the browser prompt with your Claude account. Then `/exit`.
- No Node.js needed. The native installer has no Node dependency, and the Unity MCP uses Unity's own relay binary.
- Optional: the JetBrains Claude Code plugin for Rider. Not needed for Phase 1.

## Step 9: Re-run the check
```bash
bash infra/setup_check.sh
```
Everything should be `[OK]` except the items marked "not yet": git repo and Unity MCP relay. Those come in Phase 1.

---

## Facts behind this guide (checked 2026-11-05)
- ML-Agents 4.x: Unity 6000.0+, Python 3.10.1–3.10.12 (3.10.12 recommended), `torch~=2.2.1`. Python package and Unity package versions must match. Latest Unity package: com.unity.ml-agents 4.1.0 (Jul 2026, moved from gym to gymnasium).
- Unity 6.3 is the current LTS, supported until Dec 2027. We chose 6.6 (6000.6.2f1) instead, pinned (D-013).
- Unity MCP: needs Unity 6+ and the `com.unity.ai.assistant` package in the project. Server bridge under *Project Settings → AI → Unity MCP Server*. Clients must be approved on first connection. **No built-in read-only mode is documented**, so read-only is enforced on the Claude Code side (D-012).
- Claude Code: macOS 13+, native installer `curl -fsSL https://claude.ai/install.sh | bash`, needs a Pro/Max/Team/Enterprise/Console account.
