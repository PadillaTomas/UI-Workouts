/// # UIWorkouts
///
/// The shared design system for the Workouts app ecosystem. One appearance —
/// "Ambient Dark" — no light/dark split. Layers:
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
///   `WKStatChip`, `WKSheetHeader`, `WKValueSlider`, `WKFloatingTabBar`, `WKInsetGroup`)
/// - **Catalog** (`WKCatalogView`) — a gallery for reviewing the system in isolation
///
/// A consuming app should pin `.preferredColorScheme(.dark)` at its root so the
/// system chrome (nav bars, keyboards) matches the single dark appearance.
///
/// Nothing here depends on any app. Components take primitives (`String`, `Int`
/// seconds, `WKPhase`) — never domain models.
public enum UIWorkouts {}
