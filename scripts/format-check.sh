#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

if ! command -v swiftformat >/dev/null 2>&1; then
  echo "swiftformat not found. Install with: brew install swiftformat" >&2
  exit 1
fi

cd "$ROOT_DIR"
swiftformat . --lint
