// swift-tools-version:5.9
import PackageDescription

// The design-system package has **zero external dependencies**, so a consumer
// that points at it by local path (Couch-To-Hour) inherits nothing. The
// snapshot tests and their `swift-snapshot-testing` dependency live in a nested
// package — `SnapshotTests/Package.swift` — that is never in a consumer's graph.
let package = Package(
    name: "UIWorkouts",
    platforms: [
        .iOS(.v17),
        // macOS is supported only so `swift build` / `swift test` run on the host
        // (CI, quick logic checks). The design system targets iOS.
        .macOS(.v14)
    ],
    products: [
        .library(name: "UIWorkouts", targets: ["UIWorkouts"])
    ],
    targets: [
        .target(
            name: "UIWorkouts",
            resources: [.process("Resources")]
        ),
        // Pure-logic tests. Run on the host: `swift test`.
        .testTarget(
            name: "UIWorkoutsTests",
            dependencies: ["UIWorkouts"]
        )
    ]
)
