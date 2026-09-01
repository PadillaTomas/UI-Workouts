import SwiftUI

/// Layer 2 — the top-of-screen gradient wash (handoff spec §4). First child of a
/// `ZStack`: a linear gradient from a context tint down to ``WKColor/bg``, over a
/// fixed height, with the rest of the screen sitting on plain `bg` below it.
/// Crossfades over ``WKMotion/ambientCrossfade`` when the tint changes.
public struct WKAmbientBackground: View {
    public enum Tint: Equatable {
        case neutral, run, walk, done

        var color: Color {
            switch self {
            case .neutral: return Color(rgb: 0x17202A)
            case .run: return Color(rgb: 0x241A12)
            case .walk: return Color(rgb: 0x12262B)
            case .done: return Color(rgb: 0x14211C)
            }
        }
    }

    private let tint: Tint
    private let height: CGFloat

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(_ tint: Tint = .neutral, height: CGFloat = WKSize.ambientHeight) {
        self.tint = tint
        self.height = height
    }

    /// Convenience: map a ``WKPhase`` to `.run` / `.walk`.
    public init(phase: WKPhase, height: CGFloat = WKSize.ambientHeight) {
        self.init(phase == .run ? .run : .walk, height: height)
    }

    public var body: some View {
        VStack(spacing: 0) {
            LinearGradient(
                colors: [tint.color, WKColor.bg],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: height)
            WKColor.bg
        }
        .ignoresSafeArea()
        .animation(reduceMotion ? nil : WKMotion.ambientCrossfade, value: tint)
        .accessibilityHidden(true)
    }
}

#Preview {
    ZStack(alignment: .top) {
        WKAmbientBackground(.walk)
        VStack(alignment: .leading, spacing: WKSpace.sm) {
            Text("WALK").wkFont(.labelMono).foregroundStyle(WKPhase.walk.onSoftColor)
            Text("Nice and easy").wkFont(.displayL).foregroundStyle(WKColor.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(WKSpace.xl)
        .padding(.top, WKSpace.xxxl)
    }
}
