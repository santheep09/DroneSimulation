#!/usr/bin/env bash
# Run Unity EditMode tests headless. Usage: infra/unity_test.sh [test-filter]
# Results: results/unity/editmode.xml, log: results/unity/editmode.log
# Exit: Unity's exit code (0 = all passed, 2 = test failures, other = infrastructure problem).
set -u
root="$(cd "$(dirname "$0")/.." && pwd)"
UNITY_PIN="${UNITY_PIN:-6000.6.2f1}"   # D-013
unity="/Applications/Unity/Hub/Editor/$UNITY_PIN/Unity.app/Contents/MacOS/Unity"
project="$root/RoverSim"
out="$root/results/unity"

[ -x "$unity" ] || { echo "Unity $UNITY_PIN not found at $unity" >&2; exit 10; }
[ -d "$project/ProjectSettings" ] || { echo "No Unity project at $project" >&2; exit 10; }
if pgrep -f "Unity.app/Contents/MacOS/Unity( |$)" >/dev/null; then
  echo "A Unity Editor is running (it may hold the project lock). Quit it (Cmd+Q) and rerun." >&2; exit 11
fi

mkdir -p "$out"
rm -f "$out/editmode.xml"
args=(-batchmode -nographics -projectPath "$project" -runTests -testPlatform EditMode
      -testResults "$out/editmode.xml" -logFile "$out/editmode.log")
[ $# -ge 1 ] && args+=(-testFilter "$1")

echo "Running EditMode tests (Unity $UNITY_PIN)..."
"$unity" "${args[@]}"
code=$?

if [ -f "$out/editmode.xml" ]; then
  python3 - "$out/editmode.xml" <<'PY'
import sys, xml.etree.ElementTree as ET
r = ET.parse(sys.argv[1]).getroot()
print("total=%s passed=%s failed=%s skipped=%s" % (r.get("total"), r.get("passed"), r.get("failed"), r.get("skipped")))
for c in r.iter("test-case"):
    if c.get("result") == "Failed":
        print("FAILED:", c.get("fullname"))
PY
else
  echo "No results XML produced (exit $code). Last log lines:" >&2
  tail -n 25 "$out/editmode.log" >&2
fi
echo "exit code: $code"
exit $code
