import SwiftUI

/// Layer 2 — the centrepiece of the timer screen: a full-circle progress ring
/// around a mono countdown, with a phase eyebrow. Same visual language as
/// ``WKArcGauge`` — 12pt rounded stroke, ``WKColor/border`` track, progress in
/// the phase colour, value centred in the middle — but a complete 360° ring and
/// no knob, because a countdown reads best as a closed loop draining to empty.
///
/// Takes a fraction + seconds, no domain model. The countdown keeps the mono
/// tabular face (``WKFont/timerDisplay``) rather than ``WKArcGauge``'s light sans
/// numeral: a value that changes every second must not reflow.
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
        self.fraction = min(1, max(0, fraction))
        self.phase = phase
        self.caption = caption
        self.seconds = seconds
        self.state = state
    }

    private let lineWidth: CGFloat = 12

    private var ringTint: Color {
        switch state {
        case .running: return phase.color
        case .paused: return phase.color.opacity(0.5)
        case .complete: return WKColor.stateDone
        }
    }

    private var drawnFraction: Double { state == .complete ? 1 : fraction }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(WKColor.border, lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: drawnFraction)
                .stroke(ringTint,
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))

            VStack(spacing: WKSpace.xs) {
                Text(state == .complete ? "Done" : phase.label)
                    .wkFont(.labelMono)
                    .foregroundStyle(state == .complete ? WKColor.textTertiary
                                                        : phase.onSoftColor)
                WKTimeText(seconds: seconds, size: .display)
                    .foregroundStyle(WKColor.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .multilineTextAlignment(.center)
            .padding(lineWidth * 3.5)
        }
        // The `Circle`s carry no intrinsic size, so square the whole stack and
        // let it fill the width it's given — the ring stays dead-centre.
        .padding(lineWidth / 2)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .animation(reduceMotion ? nil : WKMotion.tick, value: drawnFraction)
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
        WKTimerDial(fraction: 1, phase: .run, caption: "Interval finished.",
                    seconds: 0, state: .complete)
    }
    .frame(width: 278)
    .padding(WKSpace.xl)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(WKColor.bg)
}
