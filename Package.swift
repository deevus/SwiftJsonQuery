// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftJsonQuery",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
        .package(url: "https://github.com/g-mark/SwiftPath", from: "0.3.1"),
        .package(url: "https://github.com/ChimeHQ/SwiftTreeSitter", from: "0.7.2"),
        .package(url: "https://github.com/tree-sitter/tree-sitter-json", from: "0.20.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "SwiftJsonQuery",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftPath", package: "SwiftPath"),
                .product(name: "SwiftTreeSitter", package: "SwiftTreeSitter"),
                .product(name: "TreeSitterJSON", package: "tree-sitter-json"),
            ]),
    ]
)
