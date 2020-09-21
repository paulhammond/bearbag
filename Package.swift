// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "bearbag",
    dependencies: [
        .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.12.0"),
    ],
    targets: [
        .target(
            name: "bearbag",
            dependencies: [.product(name: "SQLite", package: "SQLite.swift") ]),
        .testTarget(
            name: "bearbagTests",
            dependencies: ["bearbag"]),
    ]
)
