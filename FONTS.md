# Fonts

The "Ambient Dark" scale (v2) uses three faces: **DM Sans** (text + big light
metric numerals), **DM Mono** (countdowns + uppercase metric eyebrows) and
**Instrument Serif** (the one reassuring headline per screen). All SIL OFL.

## ⚠️ Instrument Serif — .ttf files still need to be added

`WKFontRegistration.run` already lists `InstrumentSerif-Regular` and
`InstrumentSerif-Italic`, and `WKFont` resolves the serif cases (`displayL/M/S`)
by the family name `"Instrument Serif"`. Until the two files land the serif styles
fall back to the system serif — the package still builds and runs.

To finish: download **Instrument Serif** (Regular + Italic) from Google Fonts
(<https://fonts.google.com/specimen/Instrument+Serif>, OFL), drop
`InstrumentSerif-Regular.ttf` and `InstrumentSerif-Italic.ttf` into
`Sources/UIWorkouts/Resources/Fonts/`, add the `OFL.txt` as
`OFL-InstrumentSerif.txt`, then re-record the snapshot references.

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
