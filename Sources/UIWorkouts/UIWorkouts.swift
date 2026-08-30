/// # UIWorkouts
///
/// The shared design system for the Workouts app ecosystem. Layers:
///
/// - **Tokens** (`WKColor`, `WKPhase`, `WKSpace`, `WKRadius`, `WKSize`, `WKFont`, `WKMotion`)
/// - **Foundations** (`WKThemeMode`, `.wkFont(_:)`, `WKTimeFormat`)
/// - **Atoms** (`WKButton`, `WKCard`, `WKPill`, `WKTimeText`, `WKLabelMono`,
///   `WKRadioDot`, `WKCheckbox`, `WKToggleRow`, `WKNavRow`, `WKPhaseBar`, `WKProgressRing`)
/// - **Molecules** (`WKIntervalRow`, `WKSegmentedTrack`, `WKTimerDial`, `WKDayCell`,
///   `WKMonthGrid`, `WKChoiceCard`, `WKWeekdayPicker`, `WKWeekStrip`, `WKScaleSelector`,
///   `WKThemePicker`, `WKSectionHeader`, `WKScreenHeader`, `WKFooterActions`)
/// - **Catalog** (`WKCatalogView`) — a gallery for reviewing the system in isolation
///
/// Nothing here depends on any app. Components take primitives (`String`, `Int`
/// seconds, `WKPhase`) — never domain models. Extract this folder to its own
/// repository and only the consuming app's `Package.swift` changes.
public enum UIWorkouts {}
