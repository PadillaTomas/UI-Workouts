# Fonts

The design specifies **DM Sans** (text) and **DM Mono** (timer + mono labels), both
SIL OFL.

## Current state — the real faces are in

Bundled under `Sources/UIWorkouts/Resources/Fonts/` and registered with Core Text on
first `WKFont` use (`WKFontRegistration`) — **a consuming app needs no `UIAppFonts`
entry and no launch call.**

- `DMSans.ttf` — the variable face (`opsz` + `wght` axes). `WKFont` addresses it by
  the typographic family name `"DM Sans"`; `.weight(_:)` drives the `wght` axis, so
  every weight a component asks for resolves from the one file.
- `DMMono-Light.ttf` / `DMMono-Regular.ttf` / `DMMono-Medium.ttf` — DM Mono ships as
  separate static faces with their own family names, so `WKFont` addresses them by
  PostScript name (`DMMono-Light` etc.).
- `OFL-DMSans.txt` / `OFL-DMMono.txt` — the licenses ship with the fonts, as OFL requires.

`WKFont.Spec.font` uses `Font.custom(_:fixedSize:)`, matching the previous
**non-scaling** behaviour — Dynamic Type is still a separate change.
`.monospacedDigit()` is kept everywhere the design calls for tabular figures.

Everything downstream (`.wkFont(_:)`, every component) is unchanged — no API change.

## Updating the fonts

Replace the `.ttf` in `Resources/Fonts/`, regenerate the snapshot references
(`Scripts/record-snapshots.sh`), eyeball, commit.
