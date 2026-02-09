// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "RecordsKit",
  platforms: [.iOS(.v16), .macOS(.v10_15)],
  products: [
    .library(name: "AppFeature", targets: ["AppFeature"]),
    .library(name: "CollectionFeature", targets: ["CollectionFeature"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.23.1"),
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.11.0"),
    .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.63.2"),
    .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.59.1"),
  ],
  targets: [
    .target(
      name: "CollectionFeature",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "Dependencies", package: "swift-dependencies"),
      ]
    ),
    .target(
      name: "AppFeature",
      dependencies: [
        "CollectionFeature",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .testTarget(
      name: "CollectionFeatureTests",
      dependencies: ["CollectionFeature"]
    ),
    .testTarget(
      name: "AppFeatureTests",
      dependencies: ["AppFeature"]
    ),
  ]
)
