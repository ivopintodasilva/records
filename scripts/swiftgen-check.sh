#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
GENERATED_FILE="$ROOT_DIR/Packages/RecordsKit/Sources/Localization/Generated/L10n.generated.swift"

if ! git -C "$ROOT_DIR" diff --quiet -- "$GENERATED_FILE"; then
  echo "SwiftGen output is out of date. Run ./scripts/swiftgen.sh and include generated changes."
  git -C "$ROOT_DIR" --no-pager diff -- "$GENERATED_FILE"
  exit 1
fi
