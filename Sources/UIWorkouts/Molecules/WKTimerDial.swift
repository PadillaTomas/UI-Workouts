import SwiftUI

/// Layer 2 — the centrepiece of the timer screen: a progress ring around a mono
/// countdown, with a phase eyebrow. Takes a fraction + seconds, no domain model.
public struct WKTimerDial: View {
    public enum State { case running, paused, complete }

    private let fraction: Double
    private let phase: WKPhase
    private let caption: String
    private let seconds: Int
    private let state: State

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(
        fraction: Double,
        phase: WKPhase,
        caption: String,
        seconds: Int,
        state: State = .running
    ) {
        self.fraction = fraction
        self.phase = phase
        self.caption = caption
        self.seconds = seconds
        self.state = state
    }

    public var body: some View {
        ZStack {
            WKProgressRing(
                fraction: fraction,
                tint: state == .paused ? phase.color.opacity(0.5) : phase.color,
                track: phase.softColor,
                lineWidth: 8
            )
            VStack(spacing: WKSpace.sm) {
                Text(state == .complete ? "Done" : phase.label)
                    .wkFont(.labelMono)
                    .foregroundStyle(phase.onSoftColor)
                WKTimeText(seconds: seconds, size: .display)
                    .foregroundStyle(WKColor.textPrimary)
            }
            .padding(WKSpace.xxl)
        }
        .animation(reduceMotion ? nil : WKMotion.tick, value: fraction)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(phase.label). \(caption)")
        .accessibilityValue("\(WKTimeFormat.spoken(seconds)) remaining")
    }
}

#Preview {
    VStack(spacing: WKSpace.xxl) {
        WKTimerDial(fraction: 0.34, phase: .run,
                    caption: "Easy. You should still be able to talk.",
                    seconds: 154)
        WKTimerDial(fraction: 0.7, phase: .walk, caption: "Catch your breath.",
                    seconds: 48, state: .paused)
    }
    .frame(width: 278)
    .padding(WKSpace.xl)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(WKColor.bg)
}
