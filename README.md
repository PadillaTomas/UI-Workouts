# UIWorkouts

The shared SwiftUI design system for the Workouts app ecosystem. First consumer:
**Couch to Hour**. Ported from the "Couch to Hour iOS design" Claude Design project
(sections *1a — Design tokens* and *2a — Atomic inventory*).

## Layers

| Layer | Folder | Contents |
|---|---|---|
| 0 · Tokens | `Sources/UIWorkouts/Tokens` | `WKColor`, `WKPhase`, `WKSpace`, `WKRadius`, `WKSize`, `WKFont`, `WKMotion` |
| — · Foundations | `Sources/UIWorkouts/Foundations` | `WKThemeMode`, `.wkFont(_:)`, `WKTimeFormat`, `Color(light:dark:)` |
| 1 · Atoms | `Sources/UIWorkouts/Atoms` | `WKButton`, `WKCard`, `WKPill`, `WKTimeText`, `WKLabelMono`, `WKRadioDot`, `WKCheckbox`, `WKToggleRow`, `WKNavRow`, `WKPhaseBar`, `WKProgressRing` |
| 2 · Molecules | `Sources/UIWorkouts/Molecules` | `WKIntervalRow`, `WKSegmentedTrack`, `WKTimerDial`, `WKDayCell`, `WKMonthGrid`, `WKChoiceCard`, `WKWeekdayPicker`, `WKWeekStrip`, `WKScaleSelector`, `WKThemePicker`, `WKSectionHeader`, `WKScreenHeader`, `WKFooterActions` |
| — · Catalog | `Sources/UIWorkouts/Catalog` | `WKCatalogView` — a gallery of every component in every state |

Layer 3 (app screens — anything that names weeks, intervals or dates) stays in the app.

## Rules

- Depends only on `SwiftUI` / `Foundation`. Never imports an app.
- Components take primitives — `String`, `Int` seconds, `WKPhase` — never domain models.
  `WKIntervalRow` takes strings and seconds, not a `Session`; `WKMonthGrid` takes `[WKDay]`,
  not `Date`.
- Colors resolve light/dark from the trait environment, so call sites never branch on
  `colorScheme`. `WKThemeMode` / `WKThemePicker` only drive `.preferredColorScheme` at the
  app root.
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

Preview the whole system: open `WKCatalogView` in Xcode Previews (light + dark presets in
`WKCatalogView.swift`).

## Development

```
swift build            # host build
swift test             # unit tests (formatting, weight math, tokens)
xcodebuild -scheme UIWorkouts -destination 'generic/platform=iOS Simulator' build
```

macOS is a supported platform *only* so `swift build` / `swift test` run on the host. The
design system targets iOS 17+.

## Consuming this package

In an app's `Package.swift` (or Xcode → Add Package Dependencies):

```swift
.package(url: "https://github.com/PadillaTomas/UI-Workouts.git", from: "0.1.0")
```

then add `"UIWorkouts"` to the target's dependencies and `import UIWorkouts`.
Releases are git tags (`git tag 0.1.0 && git push --tags`); bump per semver.

See [`FONTS.md`](FONTS.md) for the one open asset item.
