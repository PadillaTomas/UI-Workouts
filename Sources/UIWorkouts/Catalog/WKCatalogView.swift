import SwiftUI

/// A scrollable gallery of every token, atom and molecule in its states. This is
/// how the design system is reviewed in isolation — drop it into any host, or
/// open the previews at the bottom of this file.
public struct WKCatalogView: View {
    public init() {}

    public var body: some View {
        ScrollView {
            WKCatalogContent()
        }
        .background(WKColor.bg)
    }
}

/// The catalog body without the enclosing `ScrollView`, so the snapshot-test
/// package (`SnapshotTests/`) can render it at its full intrinsic height.
public struct WKCatalogContent: View {
    @State private var toggle = true
    @State private var weekday = 0
    @State private var effort = 6
    @State private var choice = 0
    @State private var seg = "debt"
    @State private var tab = "today"
    @State private var goal = 300.0
    @State private var insetTones = true

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: WKSpace.xxl) {
            group("Color") { colorRow }
            group("Ramp") { rampRow }
            group("Display type (serif)") {
                Text("Nice and easy").wkFont(.displayL).foregroundStyle(WKColor.textPrimary)
                Text("That's five behind you").wkFont(.displayM)
                    .foregroundStyle(WKColor.textPrimary)
                Text("Making progress").wkFont(.displayS)
                    .foregroundStyle(WKColor.textPrimary)
            }
            group("Metric numerals (light sans)") {
                Text("72").wkFont(.metricXL).foregroundStyle(WKColor.textPrimary)
                Text("8h 20m").wkFont(.metricL).foregroundStyle(WKColor.textPrimary)
            }
            group("Ambient background") {
                ZStack(alignment: .topLeading) {
                    WKAmbientBackground(.walk, height: 160)
                    Text("WALK").wkFont(.labelMono)
                        .foregroundStyle(WKPhase.walk.onSoftColor)
                        .padding(WKSpace.lg)
                }
                .frame(height: 160)
                .clipShape(RoundedRectangle(cornerRadius: WKRadius.card, style: .continuous))
            }
            group("Arc gauge") {
                WKArcGauge(fraction: 0.72, value: "72", caption: "PLAN PROGRESS",
                           bounds: ("0", "100"),
                           segments: [.init(fraction: 1, color: WKRamp.stops[1])])
                    .frame(maxWidth: .infinity)
            }
            group("Segmented toggle") {
                WKSegmentedToggle(selection: $seg, options: [
                    (value: "debt", label: "Sleep debt"),
                    (value: "total", label: "Total sleep")
                ])
            }
            group("Metric rows") {
                WKMetricRow(title: "Total time", value: "7h 42m", fraction: 0.82,
                            tint: WKPhase.walk.color)
                WKMetricRow(title: "Consistency", value: "Good", fraction: 0.6)
                WKMetricRow(title: "This week", value: "3 of 3", showsChevron: true) {}
            }
            group("Stat cards") {
                HStack(spacing: WKSpace.md) {
                    WKStatCard(caption: "Total time", value: "8h 20m",
                               chip: ("On track", .walk), accessory: .info)
                    WKStatCard(caption: "Sessions", value: "12", accessory: .chevron) {}
                }
            }
            group("Stat chips") {
                HStack(spacing: WKSpace.sm) {
                    WKStatChip("Low", tone: .walk)
                    WKStatChip("Behind", tone: .ramp(4))
                    WKStatChip("Optimal", tone: .accent)
                    WKStatChip("Rest", tone: .neutral)
                }
            }
            group("Confirm card") {
                WKConfirmCard(title: "You missed Tuesday",
                              detail: "Mark it done if you ran anyway, or skip it.",
                              primaryLabel: "Mark done", onPrimary: {},
                              secondaryLabel: "Skip", onSecondary: {}, onDismiss: {})
            }
            group("Sheet header") {
                WKSheetHeader(title: "Edit goal", onLeading: {},
                              trailingLabel: "Save", trailingEnabled: false, onTrailing: {})
                    .background(WKColor.surface)
                    .clipShape(RoundedRectangle(cornerRadius: WKRadius.card, style: .continuous))
            }
            group("Sheet") {
                WKSheet(title: "Week 2 · Day 1", onClose: {}, scrolls: false) {
                    VStack(alignment: .leading, spacing: WKSpace.xl) {
                        WKPill("Today", tone: .run)
                        VStack(spacing: 0) {
                            WKMetricRow(title: "Time", value: "22:14")
                            WKMetricRow(title: "Felt", value: "6 — Steady")
                            WKMetricRow(title: "Status", value: "Done")
                        }
                    }
                }
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: WKRadius.sheet, style: .continuous))
            }
            group("Value slider") {
                WKValueSlider(value: $goal, range: 100...650, step: 10,
                              format: { "\(Int($0)) Cal" }, suggested: 300)
            }
            group("Floating tab bar") {
                WKFloatingTabBar(selection: $tab, items: [
                    (value: "today", systemImage: "sun.max", label: "Today"),
                    (value: "plan", systemImage: "calendar", label: "Plan"),
                    (value: "you", systemImage: "person", label: "You")
                ], trailingSystemImage: "plus", onTrailing: {})
                .frame(maxWidth: .infinity)
            }
            group("Inset group") {
                WKInsetGroup(header: "During a session",
                             footer: "Tones play at each interval change.") {
                    WKToggleRow("Interval tones", isOn: $insetTones)
                    WKNavRow("Countdown", value: "3 seconds") {}
                }
            }
            group("Buttons") {
                WKButton("Start session", style: .primary, size: .large) {}
                WKButton("Mark done", style: .secondary) {}
                WKButton("Pause", style: .soft) {}
                WKButton("Pause (walk)", style: .softPhase(.walk)) {}
                WKButton("Reset", style: .destructive) {}
                HStack {
                    WKButton("Skip", style: .quiet, size: .compact) {}
                    WKButton("Loading", isLoading: true) {}
                    WKButton("Off", action: {}).disabled(true)
                }
            }
            group("Pills & labels") {
                WKLabelMono("Week 2 · Day 1")
                HStack {
                    WKPill("Run", tone: .run)
                    WKPill("Walk", tone: .walk)
                    WKPill("Done", tone: .done)
                    WKPill("Rest", tone: .neutral)
                }
            }
            group("Time") {
                WKTimeText(seconds: 154, size: .display)
                    .foregroundStyle(WKColor.textPrimary)
                WKTimeText(seconds: 1080, size: .secondary)
                    .foregroundStyle(WKColor.textSecondary)
            }
            group("Timer dial") {
                WKTimerDial(fraction: 0.34, phase: .run,
                            caption: "You should still be able to talk.", seconds: 154)
                    .frame(width: 280, height: 280)
            }
            group("Segmented track") {
                WKSegmentedTrack(segments: sampleSegments)
            }
            group("Interval groups") {
                WKIntervalGroup(runSeconds: 60, walkSeconds: 60, repeatCount: 10)
                WKIntervalGroup(runSeconds: 3000, walkSeconds: nil, repeatCount: 1)
            }
            group("Interval rows") {
                WKIntervalRow(phase: .run, title: "Run", subtitle: "conversation pace",
                              seconds: 180, state: .active)
                WKIntervalRow(phase: .walk, title: "Walk", subtitle: "recover",
                              seconds: 90, state: .done)
            }
            group("Calendar") {
                WKMonthGrid(monthTitle: "September", weekdaySymbols: ["M","T","W","T","F","S","S"], leadingBlanks: 0, days: sampleDays, selection: 9, onStep: { _ in }, onSelect: { _ in })
            }
            group("Calendar (static)") {
                WKMonthGrid(monthTitle: "September",
                            weekdaySymbols: ["M", "T", "W", "T", "F", "S", "S"],
                            leadingBlanks: 0, days: sampleDays)
            }
            group("Choice cards") {
                WKChoiceCard(title: "3-Day Plan", body: "A rest day between sessions.",
                             isSelected: choice == 0) { choice = 0 }
                WKChoiceCard(title: "Free Run", body: "At your own pace.",
                             isSelected: choice == 1) { choice = 1 }
            }
            group("Week controls") {
                WKWeekdayPicker(symbols: ["M", "T", "W", "T", "F", "S", "S"],
                                selection: $weekday)
                WKWeekStrip(marks: [.done, .rest, .done, .rest, .scheduled, .none, .none])
            }
            group("Scale selector") {
                WKScaleSelector(selection: $effort, endLabels: ("Easy", "All out"))
            }
            group("Rows") {
                // A bare WKInsetGroup (no header/footer) — the rows are the same
                // element and the same metrics as the "Inset group" section below.
                // The last row is app-bespoke, matched with `.wkRowMetrics()`.
                WKInsetGroup {
                    WKNavRow("Mode", value: "3-Day Plan") {}
                    WKToggleRow("Interval tones", isOn: $toggle)
                    Button {} label: {
                        HStack(spacing: WKSpace.sm) {
                            Text("See all workouts").wkFont(.body)
                                .foregroundStyle(WKColor.textPrimary)
                            Spacer(minLength: WKSpace.sm)
                            Text("Week 2").wkFont(.body).foregroundStyle(WKColor.accent)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(WKColor.textTertiary)
                        }
                        .wkRowMetrics()
                    }
                    .buttonStyle(.plain)
                }
            }
            group("Headers") {
                WKScreenHeader(eyebrow: "Wednesday", title: "Week 2, Day 1",
                               body: "22 minutes · 5 run intervals")
            }
        }
        .padding(WKSpace.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(WKColor.bg)
    }

    @ViewBuilder
    private func group<Content: View>(_ title: String,
                                     @ViewBuilder _ content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: WKSpace.md) {
            WKSectionHeader(title)
            content()
        }
    }

    private var colorRow: some View {
        let swatches: [(String, Color)] = [
            ("bg", WKColor.bg), ("surface", WKColor.surface), ("sunken", WKColor.surfaceSunken),
            ("text", WKColor.textPrimary), ("accent", WKColor.accent), ("done", WKColor.stateDone),
            ("danger", WKColor.danger),
            ("run", WKPhase.run.color), ("walk", WKPhase.walk.color)
        ]
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4),
                         spacing: WKSpace.sm) {
            ForEach(swatches, id: \.0) { name, color in
                VStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: WKRadius.chip, style: .continuous)
                        .fill(color)
                        .frame(height: 44)
                        .overlay(RoundedRectangle(cornerRadius: WKRadius.chip)
                            .strokeBorder(WKColor.border, lineWidth: 1))
                    Text(name).wkFont(.caption).foregroundStyle(WKColor.textTertiary)
                }
            }
        }
    }

    private var rampRow: some View {
        HStack(spacing: WKSpace.xs) {
            ForEach(Array(WKRamp.stops.enumerated()), id: \.offset) { _, color in
                RoundedRectangle(cornerRadius: WKRadius.chip, style: .continuous)
                    .fill(color)
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private var sampleSegments: [WKTrackSegment] {
        [WKTrackSegment(id: 0, weight: 2, progress: .done, phase: .run),
         WKTrackSegment(id: 1, weight: 1, progress: .done, phase: .walk),
         WKTrackSegment(id: 2, weight: 2, progress: .current, phase: .run),
         WKTrackSegment(id: 3, weight: 1, progress: .upcoming, phase: .walk)]
    }

    private var sampleDays: [WKDay] {
        (1...28).map { d in
            WKDay(id: d, day: d,
                  state: d == 9 ? .today : (d.isMultiple(of: 2) ? .done : .scheduled))
        }
    }
}

#Preview("Catalog") {
    WKCatalogView().preferredColorScheme(.dark)
}
