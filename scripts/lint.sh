#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

swift package \
  --package-path "$ROOT_DIR/Packages/RecordsKit" \
  plugin --allow-writing-to-package-directory swiftlint -- \
  --config "$ROOT_DIR/.swiftlint.yml" \
  --strict \
  "$ROOT_DIR/Packages/RecordsKit/Sources" \
  "$ROOT_DIR/Packages/RecordsKit/Tests" \
  "$ROOT_DIR/Packages/RecordsKit/DemoApps" \
  "$ROOT_DIR/records" \
  "$ROOT_DIR/recordsTests" \
  "$ROOT_DIR/recordsUITests"
