// swift-tools-version: 5.7

import PackageDescription
import Foundation

var package = Package(
    name: "Argon",
    products: [
        .library(
            name: "Argon",
            targets: ["Argon"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Argon",
            dependencies: ["ArgonC"],
            swiftSettings: [
                // Applied to umbrella header of ArgonC
                .unsafeFlags([
                    "-Xcc", "-ISources/ArgonC/deps/olive.c",
                    "-Xcc", "-DARGON_MANAGE_CHILDREN_MANUALLY",
                ])
            ]
        ),
        .target(
            name: "ArgonC",
            sources: ["src"],
            cSettings: [
                .headerSearchPath("deps/olive.c"),
                .define("ARGON_MANAGE_CHILDREN_MANUALLY"),
            ]
        ),
        .testTarget(
            name: "ArgonTests",
            dependencies: [
                "Argon"
            ]),
    ]
)

if (ProcessInfo.processInfo.environment["ARGON_TEST"] ?? "0") == "1" {
    package.platforms = [.macOS(.v11)]
    package.dependencies.append(
        .package(url: "https://github.com/ctreffs/SwiftSDL2.git", from: "1.4.0")
    )
    package.targets.append(contentsOf: [
            .executableTarget(
                name: "ArgonExample",
                dependencies: [
                    "Argon",
                    .product(name: "SDL", package: "SwiftSDL2")
                ]
            ),
    ])
    package.targets[2].dependencies.append(
        .product(name: "SDL", package: "SwiftSDL2")
    )
}

