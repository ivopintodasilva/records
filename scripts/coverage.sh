#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

PROJECT_PATH=${PROJECT_PATH:-"$ROOT_DIR/records.xcodeproj"}
SCHEME=${SCHEME:-"records"}
DESTINATION=${DESTINATION:-"platform=iOS Simulator,name=iPhone 17"}
RESULT_BUNDLE=${RESULT_BUNDLE:-"/tmp/records-tests.xcresult"}
COVERAGE_THRESHOLD=${COVERAGE_THRESHOLD:-0.8}
TARGETS_FILE=${TARGETS_FILE:-"$ROOT_DIR/scripts/coverage_targets.txt"}

export RESULT_BUNDLE
export COVERAGE_THRESHOLD
export TARGETS_FILE

if ! command -v xcodebuild >/dev/null 2>&1; then
  echo "xcodebuild not found. Install Xcode and select it with xcode-select." >&2
  exit 1
fi

rm -rf "$RESULT_BUNDLE"

xcodebuild \
  -project "$PROJECT_PATH" \
  -scheme "$SCHEME" \
  -destination "$DESTINATION" \
  -enableCodeCoverage YES \
  -resultBundlePath "$RESULT_BUNDLE" \
  test

if [ ! -f "$TARGETS_FILE" ]; then
  echo "Targets file not found: $TARGETS_FILE" >&2
  exit 1
fi

python3 - <<'PY'
import json
import os
import subprocess
import sys

result_bundle = os.environ.get("RESULT_BUNDLE", "/tmp/records-tests.xcresult")
threshold = float(os.environ.get("COVERAGE_THRESHOLD", "0.8"))
targets_file = os.environ.get("TARGETS_FILE", "/Users/ivo/Projects/records/scripts/coverage_targets.txt")

cmd = ["xcrun", "xccov", "view", "--report", "--json", result_bundle]
report = json.loads(subprocess.check_output(cmd))

# Map target name -> coverage percent
coverage = {t["name"]: t["lineCoverage"] for t in report.get("targets", [])}

missing = []
failed = []

with open(targets_file, "r") as f:
  targets = [line.strip() for line in f if line.strip() and not line.strip().startswith("#")]

for name in targets:
  if name not in coverage:
    missing.append(name)
    continue
  value = coverage[name]
  if value < threshold:
    failed.append((name, value))

if missing:
  print("Missing coverage targets in report:")
  for name in missing:
    print(f"- {name}")

if failed:
  print("Coverage below threshold:")
  for name, value in failed:
    print(f"- {name}: {value:.2%} < {threshold:.2%}")

if missing or failed:
  sys.exit(1)

print("Coverage checks passed.")
PY
