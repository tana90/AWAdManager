// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AWAdManager",
    products: [
        .library(
            name: "AWAdManager",
            targets: ["AWAdManager"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/tana90/AWNetworkManager.git",
            from: "master"
        )
    ],
    targets: [
        .target(
            name: "AWAdManager",
            dependencies: []),
        .testTarget(
            name: "AWAdManagerTests",
            dependencies: ["AWAdManager"]),
    ]
)
