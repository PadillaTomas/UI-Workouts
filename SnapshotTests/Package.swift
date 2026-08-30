// swift-tools-version:5.9
import PackageDescription

// Visual-regression tests for UIWorkouts, kept out of the main package so the
// `swift-snapshot-testing` dependency (and its transitive `swift-syntax` /
// `xctest-dynamic-overlay`) never reach a consumer of UIWorkouts.
//
// Run:
//   cd SnapshotTests
//   xcodebuild test -scheme SnapshotTests \
//     -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.5'
//
// Regenerate references: ../Scripts/record-snapshots.sh
let package = Package(
    name: "SnapshotTests",
    platforms: [.iOS(.v17), .macOS(.v14)],
    dependencies: [
        .package(path: ".."),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.17.0")
    ],
    targets: [
        .testTarget(
            name: "SnapshotTests",
            dependencies: [
                // Path deps take their identity from the directory name.
                .product(name: "UIWorkouts", package: "UI-Workouts"),
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            path: "Tests/SnapshotTests",
            // The library reads the references from source at test time, not the
            // bundle — they're neither resources nor build inputs.
            exclude: ["__Snapshots__"]
        )
    ]
)
