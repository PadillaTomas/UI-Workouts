import SwiftUI

/// Layer 2 — pick which weekday the training week starts on. `selection` is an
/// index into `symbols` (0-based); the caller decides what index 0 means.
public struct WKWeekdayPicker: View {
    private let symbols: [String]
    @Binding private var selection: Int

    public init(symbols: [String], selection: Binding<Int>) {
        self.symbols = symbols
        self._selection = selection
    }

    public var body: some View {
        HStack(spacing: WKSpace.sm) {
            ForEach(Array(symbols.enumerated()), id: \.offset) { index, symbol in
                let isOn = index == selection
                Button {
                    selection = index
                } label: {
                    Text(symbol)
                        .font(.system(size: 15, weight: .medium, design: .monospaced))
                        .foregroundStyle(isOn ? WKColor.bg : WKColor.textSecondary)
                        .frame(width: WKSize.minTarget, height: WKSize.minTarget)
                        .background(isOn ? WKColor.textPrimary : WKColor.surface,
                                    in: Circle())
                        .overlay(Circle().strokeBorder(WKColor.border,
                                                       lineWidth: isOn ? 0 : 1))
                }
                .buttonStyle(WKPressStyle())
                .accessibilityLabel(symbol)
                .accessibilityAddTraits(isOn ? [.isSelected] : [])
            }
        }
    }
}

/// A mark on ``WKWeekStrip``.
public enum WKWeekMark: Sendable {
    case done, scheduled, rest, none
}

/// Layer 2 — a compact dot row summarising a week's sessions.
public struct WKWeekStrip: View {
    private let marks: [WKWeekMark]

    public init(marks: [WKWeekMark]) {
        self.marks = marks
    }

    public var body: some View {
        HStack(spacing: WKSpace.sm) {
            ForEach(Array(marks.enumerated()), id: \.offset) { _, mark in
                dot(for: mark)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Week overview")
    }

    @ViewBuilder private func dot(for mark: WKWeekMark) -> some View {
        switch mark {
        case .done:
            Circle().fill(WKColor.stateDone).frame(width: 8, height: 8)
        case .scheduled:
            Circle().strokeBorder(WKColor.accent, lineWidth: 1).frame(width: 8, height: 8)
        case .rest:
            Circle().fill(WKColor.border).frame(width: 8, height: 8)
        case .none:
            Circle().fill(Color.clear).frame(width: 8, height: 8)
        }
    }
}

#Preview {
    VStack(spacing: WKSpace.xl) {
        WKWeekdayPicker(symbols: ["M", "T", "W", "T", "F", "S", "S"],
                        selection: .constant(0))
        WKWeekStrip(marks: [.done, .rest, .done, .rest, .scheduled, .none, .none])
    }
    .padding(WKSpace.lg)
    .background(WKColor.bg)
}
