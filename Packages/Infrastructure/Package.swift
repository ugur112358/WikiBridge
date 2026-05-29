// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Infrastructure",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "Infrastructure", targets: ["Infrastructure"])
    ],
    dependencies: [
        .package(path: "../Domain")
    ],
    targets: [
        .target(
            name: "Infrastructure",
            dependencies: ["Domain"],
            path: "Sources/Infrastructure"
        ),
        .testTarget(
            name: "InfrastructureTests",
            dependencies: ["Infrastructure"],
            path: "Tests/InfrastructureTests"
        )
    ]
)

