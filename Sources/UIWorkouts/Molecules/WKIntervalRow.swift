import SwiftUI

/// Layer 2 — one interval in a session list. Takes strings + seconds, never a
/// domain model. Phase is shown three ways: the color bar, the title's context,
/// and (for screen readers) the accessibility label.
public struct WKIntervalRow: View {
    public enum State {
        case upcoming, active, done, skipped
    }

    private let phase: WKPhase
    private let title: String
    private let subtitle: String?
    private let seconds: Int
    private let state: State
    /// `false` drops the surface / border / clip so the row can sit inside
    /// another container (see ``WKIntervalGroup``).
    private let chrome: Bool

    public init(
        phase: WKPhase,
        title: String,
        subtitle: String? = nil,
        seconds: Int,
        state: State = .upcoming,
        chrome: Bool = true
    ) {
        self.phase = phase
        self.title = title
        self.subtitle = subtitle
        self.seconds = seconds
        self.state = state
        self.chrome = chrome
    }

    public var body: some View {
        content
            .padding(.horizontal, WKSpace.lg)
            .padding(.vertical, chrome ? WKSpace.lg : WKSpace.md)
            .background { if chrome { rowBackground } }
            .overlay { if chrome { rowBorder } }
            .clipShape(RoundedRectangle(cornerRadius: chrome ? WKRadius.card : 0, style: .continuous))
            .opacity(state == .skipped ? 0.55 : 1)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("\(phase.label), \(title). \(WKTimeFormat.spoken(seconds)). \(stateWord)")
    }

    private var content: some View {
        HStack(spacing: WKSpace.md + 2) {
            RoundedRectangle(cornerRadius: WKRadius.chip / 2, style: .continuous)
                .fill(state == .done ? WKColor.stateDone : phase.color)
                .frame(width: 8, height: 40)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .wkFont(.body)
                    .strikethrough(state == .done, color: WKColor.textTertiary)
                    .foregroundStyle(WKColor.textPrimary)
                if let subtitle {
                    Text(state == .done ? "done" : (state == .skipped ? "skipped" : subtitle))
                        .wkFont(.caption)
                        .foregroundStyle(WKColor.textSecondary)
                }
            }
            Spacer(minLength: WKSpace.sm)

            WKTimeText(seconds: seconds, size: .row)
                .foregroundStyle(state == .upcoming || state == .active
                                 ? WKColor.textPrimary : WKColor.textSecondary)
        }
    }

    private var stateWord: String {
        switch state {
        case .upcoming: return "upcoming"
        case .active: return "in progress"
        case .done: return "done"
        case .skipped: return "skipped"
        }
    }

    @ViewBuilder private var rowBackground: some View {
        switch state {
        case .active: phase.softColor
        case .done: WKColor.surfaceSunken
        default: WKColor.surface
        }
    }

    @ViewBuilder private var rowBorder: some View {
        RoundedRectangle(cornerRadius: WKRadius.card, style: .continuous)
            .strokeBorder(state == .active ? phase.color.opacity(0.5) : WKColor.border,
                          lineWidth: 1)
    }
}

#Preview {
    VStack(spacing: WKSpace.sm) {
        WKIntervalRow(phase: .walk, title: "Walk", subtitle: "warm up", seconds: 300)
        WKIntervalRow(phase: .run, title: "Run", subtitle: "conversation pace",
                      seconds: 180, state: .active)
        WKIntervalRow(phase: .walk, title: "Walk", subtitle: "recover",
                      seconds: 90, state: .done)
        WKIntervalRow(phase: .run, title: "Run", subtitle: "conversation pace",
                      seconds: 180, state: .skipped)
    }
    .padding(WKSpace.lg)
    .background(WKColor.bg)
}
