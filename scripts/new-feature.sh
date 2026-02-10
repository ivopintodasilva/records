#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: new-feature.sh <FeatureName>" >&2
  exit 1
fi

NAME="$1"
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PKG_DIR="$ROOT_DIR/Packages/RecordsKit"
PKG_FILE="$PKG_DIR/Package.swift"

if [[ ! "$NAME" =~ Feature$ ]]; then
  echo "Feature name must end with 'Feature' (example: CollectionFeature)." >&2
  exit 1
fi

if [ ! -f "$PKG_FILE" ]; then
  echo "RecordsKit package not found at $PKG_FILE" >&2
  exit 1
fi

if [ -d "$PKG_DIR/Sources/$NAME" ]; then
  echo "Target already exists: $PKG_DIR/Sources/$NAME" >&2
  exit 1
fi

mkdir -p \
  "$PKG_DIR/Sources/$NAME" \
  "$PKG_DIR/Tests/${NAME}Tests" \
  "$PKG_DIR/DemoApps/${NAME}Demo"

cat > "$PKG_DIR/Sources/$NAME/${NAME}.swift" <<SRC
import ComposableArchitecture
import Dependencies

@Reducer
public struct $NAME {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public init() {}
  }

  public enum Action {
  }

  public var body: some Reducer<State, Action> {
    Reduce { _, _ in
      .none
    }
  }
}
SRC

cat > "$PKG_DIR/Sources/$NAME/${NAME}View.swift" <<SRC
import ComposableArchitecture
import SwiftUI

public struct ${NAME}View: View {
  private let store: StoreOf<$NAME>

  public init(store: StoreOf<$NAME>) {
    self.store = store
  }

  public var body: some View {
    Text("$NAME")
  }
}
SRC

cat > "$PKG_DIR/Tests/${NAME}Tests/${NAME}Tests.swift" <<TEST
@testable import $NAME
import ComposableArchitecture
import XCTest

final class ${NAME}Tests: XCTestCase {
  func testInitialState() async {
    let store = TestStore(initialState: $NAME.State()) {
      $NAME()
    }

    XCTAssertNotNil(store.state)
  }
}
TEST

cat > "$PKG_DIR/DemoApps/${NAME}Demo/${NAME}DemoApp.swift" <<DEMO
import $NAME
import SwiftUI

@main
struct ${NAME}DemoApp: App {
  var body: some Scene {
    WindowGroup {
      ${NAME}View(
        store: Store(initialState: $NAME.State()) {
          $NAME()
        }
      )
    }
  }
}
DEMO

cat > "$PKG_DIR/DemoApps/${NAME}Demo/README.md" <<README
# $NAME Demo App

This is a standalone demo app entry point for the `$NAME` target.

## Usage
1. Create a new iOS App target in Xcode (or a small demo Xcode project).
2. Add the `RecordsKit` package as a dependency.
3. Use `${NAME}DemoApp.swift` as the app entry point.
README

python3 - <<PY
import re
from pathlib import Path

pkg = Path("$PKG_FILE")
text = pkg.read_text()

product_entry = f"    .library(name: \"{NAME}\", targets: [\"{NAME}\"])"
if product_entry not in text:
  text = re.sub(
    r"products: \[\n",
    "products: [\n" + product_entry + ",\n",
    text,
    count=1,
  )

if f"name: \"{NAME}\"" not in text:
  target_block = f"    .target(\n      name: \"{NAME}\",\n      dependencies: [\n        .product(name: \"ComposableArchitecture\", package: \"swift-composable-architecture\"),\n        .product(name: \"Dependencies\", package: \"swift-dependencies\")\n      ]\n    ),\n    .testTarget(\n      name: \"{NAME}Tests\",\n      dependencies: [\"{NAME}\"]\n    ),\n"
  text = re.sub(r"targets: \[\n", "targets: [\n" + target_block, text, count=1)

pkg.write_text(text)
PY

echo "Created $NAME in RecordsKit"
