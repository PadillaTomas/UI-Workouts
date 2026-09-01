# UIWorkouts

The shared SwiftUI design system for the Workouts app ecosystem. First consumer:
**Couch to Hour**. Ported from the "Couch to Hour iOS design" Claude Design project
(sections *1a — Design tokens* and *2a — Atomic inventory*).

## Layers

| Layer | Folder | Contents |
|---|---|---|
| 0 · Tokens | `Sources/UIWorkouts/Tokens` | `WKColor`, `WKPhase`, `WKRamp`, `WKSpace`, `WKRadius`, `WKSize`, `WKFont`, `WKMotion` |
| — · Foundations | `Sources/UIWorkouts/Foundations` | `.wkFont(_:)`, `WKTimeFormat`, `Color(rgb:)` |
| 1 · Atoms | `Sources/UIWorkouts/Atoms` | `WKButton`, `WKCard`, `WKPill`, `WKTimeText`, `WKLabelMono`, `WKRadioDot`, `WKCheckbox`, `WKToggleRow`, `WKNavRow`, `WKPhaseBar`, `WKProgressRing` |
| 2 · Molecules | `Sources/UIWorkouts/Molecules` | `WKIntervalRow`, `WKSegmentedTrack`, `WKTimerDial`, `WKDayCell`, `WKMonthGrid`, `WKChoiceCard`, `WKWeekdayPicker`, `WKWeekStrip`, `WKScaleSelector`, `WKSectionHeader`, `WKScreenHeader`, `WKFooterActions`, `WKAmbientBackground`, `WKArcGauge`, `WKSegmentedToggle`, `WKMetricRow`, `WKStatCard`, `WKConfirmCard`, `WKStatChip`, `WKSheetHeader`, `WKValueSlider`, `WKFloatingTabBar`, `WKInsetGroup` |
| — · Catalog | `Sources/UIWorkouts/Catalog` | `WKCatalogView` — a gallery of every component in every state |

Layer 3 (app screens — anything that names weeks, intervals or dates) stays in the app.

## Rules

- Depends only on `SwiftUI` / `Foundation`. Never imports an app.
- Components take primitives — `String`, `Int` seconds, `WKPhase` — never domain models.
  `WKIntervalRow` takes strings and seconds, not a `Session`; `WKMonthGrid` takes `[WKDay]`,
  not `Date`.
- One appearance — "Ambient Dark". Every token is a single fixed value; call sites never
  branch on `colorScheme`. A consuming app should pin `.preferredColorScheme(.dark)` at
  its root so the system chrome matches.
- Accessibility: Dynamic Type supported (timer digits cap at XL, tabular), 44pt min targets,
  phase is shown by color **and** text **and** position, timers expose a spoken
  `accessibilityValue`.

## Usage

```swift
import UIWorkouts

struct SomeScreen: View {
    var body: some View {
        VStack(spacing: WKSpace.lg) {
            WKScreenHeader(eyebrow: "Wednesday", title: "Week 2, Day 1",
                           body: "22 minutes · 5 run intervals")
            WKIntervalRow(phase: .run, title: "Run", subtitle: "conversation pace",
                          seconds: 180, state: .active)
        }
        .padding(WKSpace.lg)
        .background(WKColor.bg)
    }
}
```

## Browsing the components

Three ways, increasing fidelity:

1. **Xcode Previews** — every component file has a `#Preview`; `WKCatalogView.swift` has a
   full gallery preview. This is the day-to-day tool (≈ Storybook).
2. **Demo app** — `Demo/Catalog.xcodeproj`, an iPhone/iPad app that hosts `WKCatalogView`.
   Run it to click through on a real simulator or device.
   It references the package by local path, so it always tracks your working copy.
3. **Snapshot tests** — see below.

## Development

```
swift build            # host build
swift test             # pure-logic tests (formatting, weight math, tokens) — host
```

macOS is a supported platform *only* so `swift build` / `swift test` run on the host. The
design system targets iOS 17+.

### Visual-regression (snapshot) tests

These live in a **nested package** — `SnapshotTests/` — so `swift-snapshot-testing`
(and its transitive `swift-syntax` / `xctest-dynamic-overlay`) never reach a
consumer of UIWorkouts. The main package has **zero external dependencies**.

`SnapshotTests/Tests/SnapshotTests` renders `WKCatalogContent` at phone width and diffs
the pixels against the committed reference PNG in `__Snapshots__/`. This is the gate that
catches "a padding change silently broke the catalog".

```
# verify (what CI runs)
cd SnapshotTests
xcodebuild test -scheme SnapshotTests-Package -only-testing:SnapshotTests \
  -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.5'

# regenerate references after an INTENTIONAL visual change, then review + commit the PNGs
Scripts/record-snapshots.sh
```

References were recorded on **iOS 26.5**. A different iOS runtime can fail on sub-pixel
font rendering — regenerate on the target runtime if you bump it. `.github/workflows/ci.yml`
runs logic tests + snapshot tests + an iOS build on every push and PR.

### Pre-tag checklist

```
swift test                                              # logic (zero-dep package)
xcodebuild build -scheme UIWorkouts -destination 'generic/platform=iOS'
cd SnapshotTests && xcodebuild test -scheme SnapshotTests-Package \
  -only-testing:SnapshotTests \
  -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.5'
```
Green on all → safe to `git tag x.y.z && git push --tags`.

## Known gaps

- **Dynamic Type**: `WKFont` uses fixed point sizes, so text does not yet scale with the
  user's content-size setting (the `dynamic-a11y` snapshot is the baseline for when it
  does). Timer digits already cap at XL by design.

## Consuming this package

In an app's `Package.swift` (or Xcode → Add Package Dependencies):

```swift
.package(url: "https://github.com/PadillaTomas/UI-Workouts.git", from: "0.1.0")
```

then add `"UIWorkouts"` to the target's dependencies and `import UIWorkouts`.
Releases are git tags (`git tag 0.1.0 && git push --tags`); bump per semver.

DM Sans / DM Mono are bundled and self-register — see [`FONTS.md`](FONTS.md).
