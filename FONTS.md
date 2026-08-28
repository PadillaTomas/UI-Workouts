# Fonts — the one open asset item

The design specifies **DM Sans** (text) and **DM Mono** (timer + mono labels), both
SIL OFL, available from Google Fonts.

## Current state

`WKFont` resolves to the **system faces** as a faithful fallback:

- text styles → `.system(size:weight:)` (San Francisco)
- `timerDisplay` / `timerSecondary` / `labelMono` → `.system(..., design: .monospaced)`
  with `.monospacedDigit()` for the tabular figures the timer needs

This renders correctly today — the real faces are a visual refinement, not a blocker.

## Switching to the real faces (no API change)

1. Add the `.ttf` files to a new `Sources/UIWorkouts/Resources/Fonts/` folder:
   `DMSans-Regular.ttf`, `DMSans-Medium.ttf`, `DMSans-Bold.ttf`,
   `DMMono-Light.ttf`, `DMMono-Regular.ttf`, `DMMono-Medium.ttf`.
2. In `Package.swift`, add `resources: [.process("Resources")]` to the `UIWorkouts` target.
3. In `WKFont.Spec.font`, return `.custom("DM Sans", size:)` / `.custom("DM Mono", size:)`
   (register them once at launch with `CTFontManagerRegisterFontsForURL` over the bundle,
   or via an `Info.plist` `UIAppFonts` entry in each consuming app).

Everything downstream (`.wkFont(_:)`, every component) is unchanged.
