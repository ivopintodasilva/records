// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "CollectionFeature",
  platforms: [.iOS(.v16)],
  products: [
    .library(name: "CollectionFeature", targets: ["CollectionFeature"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.22.3"),
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.10.0"),
  ],
  targets: [
    .target(
      name: "CollectionFeature",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "Dependencies", package: "swift-dependencies"),
      ]
    ),
    .testTarget(
      name: "CollectionFeatureTests",
      dependencies: ["CollectionFeature"]
    ),
  ]
)
