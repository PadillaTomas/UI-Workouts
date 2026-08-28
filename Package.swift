// swift-tools-version:5.9
import PackageDescription

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
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.17.0")
    ],
    targets: [
        .target(
            name: "UIWorkouts"
        ),
        // Pure-logic tests. Run on the host: `swift test`.
        .testTarget(
            name: "UIWorkoutsTests",
            dependencies: ["UIWorkouts"]
        ),
        // Visual-regression tests. iOS only — run via:
        // xcodebuild test -scheme UIWorkouts-Package \
        //   -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.5'
        // The test bodies are #if canImport(UIKit)-guarded so this target still
        // compiles (empty) during a host `swift test`.
        .testTarget(
            name: "UIWorkoutsSnapshotTests",
            dependencies: [
                "UIWorkouts",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]
        )
    ]
)
