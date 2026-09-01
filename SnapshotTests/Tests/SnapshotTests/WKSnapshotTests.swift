#if canImport(UIKit)
import SwiftUI
import UIKit
import XCTest
import SnapshotTesting
import UIWorkouts

/// Visual-regression coverage for the design system.
///
/// Renders the whole `WKCatalogView` (every token, atom and molecule) at a
/// phone-width layout and diffs the pixels against the committed reference image
/// in `__Snapshots__/`. One image — the system has a single "Ambient Dark"
/// appearance and the ecosystem is phone-first — which catches the large
/// majority of real regressions without a device matrix to re-record on every
/// Xcode bump.
///
/// Regenerate the references after an intentional visual change:
/// ```
/// Scripts/record-snapshots.sh
/// ```
/// then review the changed PNGs before committing. CI (`.github/workflows/ci.yml`)
/// runs the same tests without recording and fails on any diff.
final class WKSnapshotTests: XCTestCase {

    private var recording: Bool {
        ProcessInfo.processInfo.environment["SNAPSHOT_RECORD"] == "1"
    }

    private func traits(_ style: UIUserInterfaceStyle) -> UITraitCollection {
        UITraitCollection(traitsFrom: [
            UITraitCollection(userInterfaceStyle: style),
            UITraitCollection(preferredContentSizeCategory: .large),
        ])
    }

    /// The whole catalog at its natural height, so content below the fold is
    /// covered too.
    func test_catalog_fullLength() {
        let view = WKCatalogContent()
            .frame(width: 390)
        assertSnapshot(
            of: view,
            as: .image(layout: .sizeThatFits, traits: traits(.dark)),
            named: "compact-dark",
            record: recording
        )
    }
}
#endif
