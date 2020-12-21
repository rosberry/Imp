// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Imp",
    platforms: [.iOS(.v11)],
    products: [
        .library(name: "Imp", targets: ["Imp"]),
    ],
    targets: [
        .target(name: "Imp", path: "Imp/Sources"),
        .testTarget(name: "ImpTests", dependencies: ["Imp"], path: "Imp/Tests")
    ]
)
