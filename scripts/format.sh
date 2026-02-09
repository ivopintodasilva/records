#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

swift package \
  --package-path "$ROOT_DIR/Packages/RecordsKit" \
  plugin --allow-writing-to-package-directory swiftformat -- \
  "$ROOT_DIR"
