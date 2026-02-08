#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

"$ROOT_DIR/scripts/lint.sh"
"$ROOT_DIR/scripts/format-check.sh"
"$ROOT_DIR/scripts/coverage.sh"
