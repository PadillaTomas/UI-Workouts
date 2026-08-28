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

/// The catalog body without the enclosing `ScrollView`, so snapshot tests can
/// render it at its full intrinsic height. Not part of the public API.
struct WKCatalogContent: View {
    @State private var theme: WKThemeMode = .system
    @State private var toggle = true
    @State private var weekday = 0
    @State private var effort = 6
    @State private var choice = 0

    var body: some View {
        VStack(alignment: .leading, spacing: WKSpace.xxl) {
            group("Color") { colorRow }
            group("Buttons") {
                WKButton("Start session", style: .primary, size: .large) {}
                WKButton("Mark done", style: .secondary) {}
                WKButton("Pause", style: .soft) {}
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
                    .frame(width: 260, height: 260)
            }
            group("Segmented track") {
                WKSegmentedTrack(segments: sampleSegments)
            }
            group("Interval rows") {
                WKIntervalRow(phase: .run, title: "Run", subtitle: "conversation pace",
                              seconds: 180, state: .active)
                WKIntervalRow(phase: .walk, title: "Walk", subtitle: "recover",
                              seconds: 90, state: .done)
            }
            group("Calendar") {
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
                VStack(spacing: 0) {
                    WKNavRow("Mode", value: "3-Day Plan") {}
                    WKToggleRow("Interval tones", isOn: $toggle)
                }
                .background(WKColor.surface)
                .clipShape(RoundedRectangle(cornerRadius: WKRadius.card, style: .continuous))
            }
            group("Theme picker") {
                WKThemePicker(selection: $theme)
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

#Preview("Catalog — light") {
    WKCatalogView().wkThemeMode(.light)
}

#Preview("Catalog — dark") {
    WKCatalogView().wkThemeMode(.dark)
}
