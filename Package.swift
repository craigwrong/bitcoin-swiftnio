// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "bitcoin-swiftnio",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.3"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.62.0")],
    targets: [
        .target(name: "Model"),
        .target(
            name: "Networking",
            dependencies: [
                "Model",
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio")]),
        .executableTarget(
            name: "BitcoinP2P", dependencies: [
                "Networking",
                .product(name: "ArgumentParser", package: "swift-argument-parser")]),
        .testTarget(
            name: "ModelTests",
            dependencies: [ "Model"]
            ),])
