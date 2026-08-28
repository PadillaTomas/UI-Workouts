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
    targets: [
        .target(
            name: "UIWorkouts"
        ),
        .testTarget(
            name: "UIWorkoutsTests",
            dependencies: ["UIWorkouts"]
        )
    ]
)
