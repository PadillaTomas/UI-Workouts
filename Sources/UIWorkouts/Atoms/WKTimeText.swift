import SwiftUI

/// Layer 1 — a duration rendered as a clock, with tabular figures and a spoken
/// accessibility label ("2 minutes 5 seconds").
public struct WKTimeText: View {
    public enum Size {
        /// The big dial readout.
        case display
        /// Session-total / secondary.
        case secondary
        /// Inline in a row.
        case row

        var font: WKFont {
            switch self {
            case .display: return .timerDisplay
            case .secondary: return .timerSecondary
            case .row: return .body
            }
        }
    }

    private let seconds: Int
    private let size: Size

    public init(seconds: Int, size: Size = .row) {
        self.seconds = seconds
        self.size = size
    }

    public var body: some View {
        Text(WKTimeFormat.clock(seconds))
            .wkFont(size.font)
            .monospacedDigit()
            .accessibilityLabel(WKTimeFormat.spoken(seconds))
    }
}

#Preview {
    VStack(alignment: .leading, spacing: WKSpace.lg) {
        WKTimeText(seconds: 154, size: .display)
        WKTimeText(seconds: 1080, size: .secondary)
        WKTimeText(seconds: 90, size: .row)
    }
    .foregroundStyle(WKColor.textPrimary)
    .padding(WKSpace.xl)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(WKColor.bg)
}
