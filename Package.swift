// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyFramework",
    platforms: [.iOS(.v11)],
    products: [
        .library(name: "MyFramework", targets: ["MyFramework"]),
    ],
    targets: [
        .target(name: "MyFramework", path: "MyFramework/Sources"),
        .testTarget(name: "MyFrameworkTests", dependencies: ["MyFramework"], path: "MyFramework/Tests")
    ]
)
