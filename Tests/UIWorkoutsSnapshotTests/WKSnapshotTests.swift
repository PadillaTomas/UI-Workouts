#if canImport(UIKit)
import SwiftUI
import UIKit
import XCTest
import SnapshotTesting
@testable import UIWorkouts

/// Visual-regression coverage for the design system.
///
/// These render `WKCatalogView` (every token, atom and molecule) across a matrix
/// of device width, orientation, light/dark and Dynamic Type, and diff the pixels
/// against committed reference images in `__Snapshots__/`.
///
/// Regenerate references after an intentional visual change:
/// ```
/// SNAPSHOT_RECORD=1 xcodebuild test -scheme UIWorkouts-Package \
///   -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.5' \
///   -only-testing:UIWorkoutsSnapshotTests
/// ```
/// then review and commit the changed PNGs. CI runs the same command without the
/// env var and fails on any diff.
final class WKSnapshotTests: XCTestCase {

    private var recording: Bool {
        ProcessInfo.processInfo.environment["SNAPSHOT_RECORD"] == "1"
    }

    private func traits(_ style: UIUserInterfaceStyle,
                        _ size: UIContentSizeCategory = .large) -> UITraitCollection {
        UITraitCollection(traitsFrom: [
            UITraitCollection(userInterfaceStyle: style),
            UITraitCollection(preferredContentSizeCategory: size),
        ])
    }

    // MARK: Full-length content, by layout width

    /// The whole catalog at its natural height, so content below the fold is
    /// covered too. One image per width class × appearance, plus one large
    /// Dynamic Type run.
    ///
    /// Note: `WKFont` currently uses fixed point sizes, so `dynamic-a11y` looks
    /// the same as `compact-light` today — the reference image is the baseline
    /// for when the type scale gains Dynamic Type support (see repo TODO).
    func test_catalog_fullLength() {
        let cases: [(name: String, width: CGFloat, style: UIUserInterfaceStyle,
                     dynamicType: DynamicTypeSize)] = [
            ("compact-light",   390, .light, .large),
            ("compact-dark",    390, .dark,  .large),
            ("dynamic-a11y",    390, .light, .accessibility3),
            ("regular-light",   744, .light, .large),
            ("regular-dark",    744, .dark,  .large),
        ]
        for c in cases {
            let view = WKCatalogContent()
                .frame(width: c.width)
                .environment(\.dynamicTypeSize, c.dynamicType)
            assertSnapshot(
                of: view,
                as: .image(layout: .sizeThatFits, traits: traits(c.style)),
                named: c.name,
                record: recording
            )
        }
    }

    // MARK: Device + orientation

    /// The catalog inside a real device frame — validates safe-area insets and
    /// device metrics. Clipped to one screen; that is intentional.
    func test_catalog_devices() {
        let cases: [(name: String, config: ViewImageConfig, style: UIUserInterfaceStyle)] = [
            ("iphone-se-portrait",       .iPhoneSe(.portrait),         .light),
            ("iphone-se-portrait-dark",  .iPhoneSe(.portrait),         .dark),
            ("iphone-max-landscape",     .iPhone13ProMax(.landscape),  .light),
            ("ipad-portrait",            .iPadPro11(.portrait),        .light),
            ("ipad-landscape",           .iPadPro11(.landscape),       .light),
        ]
        for c in cases {
            assertSnapshot(
                of: UIHostingController(rootView: WKCatalogView()),
                as: .image(on: c.config, traits: traits(c.style)),
                named: c.name,
                record: recording
            )
        }
    }
}
#endif
