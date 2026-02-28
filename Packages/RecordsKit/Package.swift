// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "RecordsKit",
  defaultLocalization: "en",
  platforms: [.iOS("26.0"), .macOS(.v13)],
  products: [
    .library(name: "AddRecordFeature", targets: ["AddRecordFeature"]),
    .library(name: "AppFeature", targets: ["AppFeature"]),
    .library(name: "CollectionFeature", targets: ["CollectionFeature"]),
    .library(name: "Localization", targets: ["Localization"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.23.1"),
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.11.0"),
    .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.63.2"),
    .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.59.1"),
    .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", from: "6.6.2"),
  ],
  targets: [
    .target(
      name: "AddRecordFeature",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "Dependencies", package: "swift-dependencies"),
      ]
    ),
    .target(
      name: "Localization",
      resources: [
        .process("Resources"),
      ]
    ),
    .target(
      name: "CollectionFeature",
      dependencies: [
        "AddRecordFeature",
        "Localization",
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
      name: "AddRecordFeatureTests",
      dependencies: ["AddRecordFeature"]
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
