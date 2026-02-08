#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: new-feature.sh <FeatureName>" >&2
  exit 1
fi

NAME="$1"
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PACKAGE_DIR="$ROOT_DIR/Packages/$NAME"

if [[ ! "$NAME" =~ Feature$ ]]; then
  echo "Feature name must end with 'Feature' (example: CollectionFeature)." >&2
  exit 1
fi

if [ -d "$PACKAGE_DIR" ]; then
  echo "Package already exists: $PACKAGE_DIR" >&2
  exit 1
fi

mkdir -p \
  "$PACKAGE_DIR/Sources/$NAME" \
  "$PACKAGE_DIR/Tests/${NAME}Tests" \
  "$PACKAGE_DIR/DemoApps/${NAME}Demo"

cat > "$PACKAGE_DIR/Package.swift" <<PKG
// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "$NAME",
  platforms: [.iOS(.v16)],
  products: [
    .library(name: "$NAME", targets: ["$NAME"])
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.22.3"),
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.10.0")
  ],
  targets: [
    .target(
      name: "$NAME",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "Dependencies", package: "swift-dependencies")
      ]
    ),
    .testTarget(
      name: "${NAME}Tests",
      dependencies: ["$NAME"]
    )
  ]
)
PKG

cat > "$PACKAGE_DIR/Sources/$NAME/${NAME}.swift" <<SRC
import ComposableArchitecture
import Dependencies
import SwiftUI

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

cat > "$PACKAGE_DIR/Tests/${NAME}Tests/${NAME}Tests.swift" <<TEST
import ComposableArchitecture
import XCTest

@testable import $NAME

final class ${NAME}Tests: XCTestCase {
  func testPlaceholder() async {
    let store = TestStore(initialState: $NAME.State()) {
      $NAME()
    }
    XCTAssertNotNil(store.state)
  }
}
TEST

cat > "$PACKAGE_DIR/DemoApps/${NAME}Demo/${NAME}DemoApp.swift" <<DEMO
import ComposableArchitecture
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

cat > "$PACKAGE_DIR/DemoApps/${NAME}Demo/README.md" <<README
# $NAME Demo App

This is a standalone demo app entry point for the `$NAME` package.

## Usage
1. Create a new iOS App target in Xcode (or a small demo Xcode project).
2. Add the `$NAME` package as a dependency.
3. Use `${NAME}DemoApp.swift` as the app entry point.
README

echo "Created $NAME at $PACKAGE_DIR"
