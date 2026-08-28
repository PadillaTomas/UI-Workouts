import SwiftUI

/// Layer 2 — a repeated run/walk block shown as **one card** with an `×N`
/// header, instead of N separate rows. `walkSeconds == nil` is a run with no
/// recovery walk (a single continuous run).
///
/// Takes primitives only. The caller groups its domain intervals; this just
/// draws the card.
public struct WKIntervalGroup: View {
    private let runSeconds: Int
    private let walkSeconds: Int?
    private let repeatCount: Int
    private let state: WKIntervalRow.State

    public init(
        runSeconds: Int,
        walkSeconds: Int?,
        repeatCount: Int,
        state: WKIntervalRow.State = .upcoming
    ) {
        self.runSeconds = runSeconds
        self.walkSeconds = walkSeconds
        self.repeatCount = max(1, repeatCount)
        self.state = state
    }

    private var blockSeconds: Int { (runSeconds + (walkSeconds ?? 0)) * repeatCount }

    public var body: some View {
        VStack(spacing: 0) {
            if repeatCount > 1 {
                HStack {
                    WKLabelMono("×\(repeatCount)")
                    Spacer(minLength: WKSpace.sm)
                    WKTimeText(seconds: blockSeconds, size: .row)
                        .foregroundStyle(WKColor.textTertiary)
                }
                .padding(.horizontal, WKSpace.lg)
                .padding(.top, WKSpace.md)
                .padding(.bottom, WKSpace.xs)
            }

            WKIntervalRow(phase: .run, title: "Run", seconds: runSeconds,
                          state: state, chrome: false)

            if let walkSeconds {
                Divider().overlay(WKColor.border)
                    .padding(.leading, WKSpace.lg)
                WKIntervalRow(phase: .walk, title: "Walk", seconds: walkSeconds,
                              state: state, chrome: false)
            }
        }
        .padding(.vertical, repeatCount > 1 ? WKSpace.xs : 0)
        .background(state == .done ? WKColor.surfaceSunken : WKColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: WKRadius.card, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: WKRadius.card, style: .continuous)
                .strokeBorder(WKColor.border, lineWidth: 1)
        )
        .opacity(state == .skipped ? 0.55 : 1)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
    }

    private var accessibilityLabel: String {
        var parts = ["Run \(WKTimeFormat.spoken(runSeconds))"]
        if let walkSeconds { parts.append("walk \(WKTimeFormat.spoken(walkSeconds))") }
        var label = parts.joined(separator: ", ")
        if repeatCount > 1 { label += ", repeated \(repeatCount) times" }
        return label
    }
}

#Preview {
    ScrollView {
        VStack(spacing: WKSpace.sm) {
            WKIntervalGroup(runSeconds: 60, walkSeconds: 60, repeatCount: 10)
            WKIntervalGroup(runSeconds: 120, walkSeconds: 60, repeatCount: 5, state: .done)
            WKIntervalGroup(runSeconds: 300, walkSeconds: 60, repeatCount: 1)
            WKIntervalGroup(runSeconds: 3000, walkSeconds: nil, repeatCount: 1)
        }
        .padding(WKSpace.lg)
    }
    .background(WKColor.bg)
}
