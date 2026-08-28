import SwiftUI

/// A calendar day for ``WKMonthGrid``. Generic: an integer and a state, no `Date`.
public struct WKDay: Identifiable, Sendable {
    public enum State: Sendable {
        case `default`, done, today, scheduled, rest, outsideMonth
    }

    public let id: Int
    public var day: Int
    public var state: State

    public init(id: Int, day: Int, state: State) {
        self.id = id
        self.day = day
        self.state = state
    }
}

/// Layer 2 — a single calendar cell.
public struct WKDayCell: View {
    private let day: Int
    private let state: WKDay.State

    public init(day: Int, state: WKDay.State) {
        self.day = day
        self.state = state
    }

    public var body: some View {
        ZStack {
            shape
            VStack(spacing: 4) {
                Text("\(day)")
                    .font(.system(size: 15, design: .monospaced))
                    .foregroundStyle(numberColor)
                dot
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .opacity(state == .outsideMonth ? 0.5 : 1)
        .accessibilityLabel("Day \(day)")
        .accessibilityValue(accessibilityValue)
    }

    @ViewBuilder private var shape: some View {
        let r = RoundedRectangle(cornerRadius: WKRadius.cell, style: .continuous)
        switch state {
        case .default, .outsideMonth:
            r.fill(WKColor.surface).overlay(r.strokeBorder(WKColor.border, lineWidth: 1))
        case .done:
            r.fill(Color(light: 0xEAF0E8, dark: 0x22301F))
                .overlay(r.strokeBorder(WKColor.stateDone.opacity(0.4), lineWidth: 1))
        case .today:
            r.fill(WKColor.textPrimary)
        case .scheduled:
            r.fill(WKColor.surface).overlay(
                r.strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
                    .foregroundStyle(WKColor.border)
            )
        case .rest:
            r.fill(WKColor.surfaceSunken)
        }
    }

    @ViewBuilder private var dot: some View {
        switch state {
        case .done:
            Circle().fill(WKColor.stateDone).frame(width: 5, height: 5)
        case .today:
            Circle().fill(WKColor.accent).frame(width: 5, height: 5)
        case .scheduled:
            Circle().strokeBorder(WKColor.accent, lineWidth: 1).frame(width: 5, height: 5)
        default:
            Color.clear.frame(width: 5, height: 5)
        }
    }

    private var numberColor: Color {
        switch state {
        case .today: return WKColor.bg
        case .done: return WKColor.stateDone
        case .rest: return WKColor.textTertiary
        default: return WKColor.textSecondary
        }
    }

    private var accessibilityValue: String {
        switch state {
        case .default, .outsideMonth: return ""
        case .done: return "completed"
        case .today: return "today"
        case .scheduled: return "scheduled"
        case .rest: return "rest day"
        }
    }
}

/// Layer 2 — a month grid. `leadingBlanks` shifts the first day to its weekday
/// column. Weekday header symbols are supplied by the caller (locale is the
/// app's concern, not the package's). Pass `onStep` to get prev/next month
/// chevrons beside the title; pass `onSelect` to make the day cells tappable.
public struct WKMonthGrid: View {
    private let monthTitle: String
    private let weekdaySymbols: [String]
    private let leadingBlanks: Int
    private let days: [WKDay]
    private let selection: Int?
    private let onStep: ((Int) -> Void)?
    private let onSelect: ((WKDay) -> Void)?

    public init(
        monthTitle: String,
        weekdaySymbols: [String],
        leadingBlanks: Int,
        days: [WKDay],
        selection: Int? = nil,
        onStep: ((Int) -> Void)? = nil,
        onSelect: ((WKDay) -> Void)? = nil
    ) {
        self.monthTitle = monthTitle
        self.weekdaySymbols = weekdaySymbols
        self.leadingBlanks = max(0, leadingBlanks)
        self.days = days
        self.selection = selection
        self.onStep = onStep
        self.onSelect = onSelect
    }

    private let columns = Array(repeating: GridItem(.flexible(), spacing: WKSpace.sm), count: 7)

    public var body: some View {
        VStack(alignment: .leading, spacing: WKSpace.md) {
            HStack {
                Text(monthTitle)
                    .wkFont(.titleL)
                    .foregroundStyle(WKColor.textPrimary)
                if let onStep {
                    Spacer(minLength: WKSpace.md)
                    HStack(spacing: WKSpace.lg) {
                        stepButton("chevron.left", -1, onStep)
                        stepButton("chevron.right", 1, onStep)
                    }
                }
            }
            LazyVGrid(columns: columns, spacing: WKSpace.sm) {
                ForEach(gridCells) { cell in
                    switch cell {
                    case let .header(_, symbol):
                        Text(symbol)
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundStyle(WKColor.textTertiary)
                    case .blank:
                        Color.clear.frame(height: 1)
                    case let .day(day):
                        dayCell(day)
                    }
                }
            }
        }
    }

    private enum GridCell: Identifiable {
        case header(Int, String)
        case blank(Int)
        case day(WKDay)
        var id: String {
            switch self {
            case let .header(i, _): return "h\(i)"
            case let .blank(i): return "b\(i)"
            case let .day(day): return "d\(day.id)"
            }
        }
    }

    private var gridCells: [GridCell] {
        weekdaySymbols.enumerated().map { GridCell.header($0.offset, $0.element) }
            + (0..<leadingBlanks).map { GridCell.blank($0) }
            + days.map { GridCell.day($0) }
    }

    @ViewBuilder private func dayCell(_ day: WKDay) -> some View {
        let cell = WKDayCell(day: day.day, state: day.state)
            .overlay {
                if day.day == selection {
                    RoundedRectangle(cornerRadius: WKRadius.cell, style: .continuous)
                        .strokeBorder(WKColor.accent, lineWidth: 2)
                }
            }
        if let onSelect {
            Button { onSelect(day) } label: { cell }
                .buttonStyle(WKPressStyle())
        } else {
            cell
        }
    }

    private func stepButton(_ symbol: String, _ delta: Int,
                            _ onStep: @escaping (Int) -> Void) -> some View {
        Button { onStep(delta) } label: {
            Image(systemName: symbol)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(WKColor.textSecondary)
                .frame(width: WKSize.minTarget, height: WKSize.minTarget)
        }
        .buttonStyle(WKPressStyle())
        .accessibilityLabel(delta < 0 ? "Previous month" : "Next month")
    }
}

#Preview {
    WKMonthGrid(
        monthTitle: "September",
        weekdaySymbols: ["M", "T", "W", "T", "F", "S", "S"],
        leadingBlanks: 0,
        days: (1...28).map { d in
            WKDay(id: d, day: d,
                  state: d == 9 ? .today : (d.isMultiple(of: 2) ? .done : .scheduled))
        }
    )
    .padding(WKSpace.lg)
    .background(WKColor.bg)
}
