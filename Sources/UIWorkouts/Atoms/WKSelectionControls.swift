import SwiftUI

/// Layer 1 — a radio dot (used by choice lists). Presentation only; the parent
/// owns selection state.
public struct WKRadioDot: View {
    private let isOn: Bool

    public init(isOn: Bool) {
        self.isOn = isOn
    }

    public var body: some View {
        ZStack {
            Circle()
                .strokeBorder(isOn ? WKColor.accent : WKColor.border, lineWidth: 1.5)
            if isOn {
                Circle()
                    .fill(WKColor.accent)
                    .padding(5)
            }
        }
        .frame(width: 20, height: 20)
        .accessibilityHidden(true)
    }
}

/// Layer 1 — a checkbox (used by the disclaimer gate). Presentation only.
public struct WKCheckbox: View {
    private let isOn: Bool

    public init(isOn: Bool) {
        self.isOn = isOn
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: 5, style: .continuous)
            .strokeBorder(isOn ? WKColor.accent : WKColor.border, lineWidth: 1.5)
            .background(
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(isOn ? WKColor.accent : Color.clear)
            )
            .overlay {
                if isOn {
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(WKColor.bg)
                }
            }
            .frame(width: 20, height: 20)
            .accessibilityHidden(true)
    }
}

#Preview {
    HStack(spacing: WKSpace.lg) {
        WKRadioDot(isOn: true)
        WKRadioDot(isOn: false)
        WKCheckbox(isOn: true)
        WKCheckbox(isOn: false)
    }
    .padding(WKSpace.xl)
    .background(WKColor.bg)
}
