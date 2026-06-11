// swift-tools-version:5.9

import PackageDescription
import Foundation

let isGitHubActions = ProcessInfo.processInfo.environment["GITHUB_ACTIONS"] == "true"
let disableBenchmark = true
let benchmarkDependencies: [Package.Dependency] = (isGitHubActions || disableBenchmark) ? [] : [
    .package(url: "https://github.com/ordo-one/package-benchmark", .upToNextMajor(from: "1.29.11"))
]

let products: [Product] = [
    .executable(name: "SwiftTermFuzz", targets: ["SwiftTermFuzz"]),
    .executable(name: "termcast", targets: ["Termcast"]),
    .library(
        name: "SwiftTerm",
        targets: ["SwiftTerm"]
    ),
]

let benchmarkTargets: [Target] = (isGitHubActions || disableBenchmark) ? [] : [
    .executableTarget(
        name: "SwiftTermBenchmarks",
        dependencies: [
            "SwiftTerm",
            .product(name: "Benchmark", package: "package-benchmark")
        ],
        path: "Benchmarks/SwiftTermBenchmarks",
        plugins: [
            .plugin(name: "BenchmarkPlugin", package: "package-benchmark")
        ]
    )
]

let targets: [Target] = [
    .target(
        name: "SwiftTerm",
        //
        // We can not use Swift Subprocess, because there is no way of configuring the child process to
        // be a controlling terminal, as it is posix-spawn based.
        path: "Sources/SwiftTerm",
        exclude: ["Mac/README.md"],
        resources: [
            .process("Apple/Metal/Shaders.metal")
        ]
//        swiftSettings: [
//            .unsafeFlags(["-enforce-exclusivity=none"])
//        ]
    ),
    .executableTarget (
        name: "SwiftTermFuzz",
        dependencies: ["SwiftTerm"],
        path: "Sources/SwiftTermFuzz"
    ),
    .executableTarget (
        name: "Termcast",
        dependencies: [
            "SwiftTerm",
            .product(name: "ArgumentParser", package: "swift-argument-parser")
        ],
        path: "Sources/Termcast"
    ),
    .testTarget(
        name: "SwiftTermTests",
        dependencies: ["SwiftTerm"],
        path: "Tests/SwiftTermTests"
    )
] + benchmarkTargets

let package = Package(
    name: "SwiftTerm",
    platforms: [
        (disableBenchmark ? .macOS(.v11) : .macOS(.v13))
    ],
    products: products,
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.4.3"),
    ] + benchmarkDependencies,
//        .package(url: "https://github.com/swiftlang/swift-subprocess", revision: "426790f3f24afa60b418450da0afaa20a8b3bdd4")
    targets: targets,
    swiftLanguageVersions: [.v5]
)
