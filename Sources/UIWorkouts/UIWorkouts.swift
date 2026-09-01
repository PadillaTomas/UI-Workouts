/// # UIWorkouts
///
/// The shared design system for the Workouts app ecosystem. "Ambient Dark" is
/// the primary theme; a light appearance is carried alongside it (AA-safe) and
/// every semantic token resolves itself against the trait environment. Layers:
///
/// - **Tokens** (`WKColor`, `WKPhase`, `WKRamp`, `WKSpace`, `WKRadius`, `WKSize`,
///   `WKFont`, `WKMotion`)
/// - **Foundations** (`.wkFont(_:)`, `WKTimeFormat`)
/// - **Atoms** (`WKButton`, `WKCard`, `WKPill`, `WKTimeText`, `WKLabelMono`,
///   `WKRadioDot`, `WKCheckbox`, `WKToggleRow`, `WKNavRow`, `WKPhaseBar`, `WKProgressRing`)
/// - **Molecules** (`WKIntervalRow`, `WKSegmentedTrack`, `WKTimerDial`, `WKDayCell`,
///   `WKMonthGrid`, `WKChoiceCard`, `WKWeekdayPicker`, `WKWeekStrip`, `WKScaleSelector`,
///   `WKSectionHeader`, `WKScreenHeader`, `WKFooterActions`, `WKAmbientBackground`,
///   `WKArcGauge`, `WKSegmentedToggle`, `WKMetricRow`, `WKStatCard`, `WKConfirmCard`,
///   `WKStatChip`, `WKSheetHeader`, `WKSheet`, `WKValueSlider`, `WKFloatingTabBar`,
///   `WKInsetGroup`, `WKThemePicker`)
/// - **Catalog** (`WKCatalogView`) — a gallery for reviewing the system in isolation
///
/// A consuming app drives appearance from its own `WKAppearance` preference —
/// `.preferredColorScheme(pref.colorScheme)` at the root (`nil` follows the
/// system) — and can surface it with `WKThemePicker`.
///
/// Nothing here depends on any app. Components take primitives (`String`, `Int`
/// seconds, `WKPhase`) — never domain models.
public enum UIWorkouts {}
