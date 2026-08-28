import SwiftUI

/// Layer 1 — the uppercase mono eyebrow used above titles and as a section kicker.
public struct WKLabelMono: View {
    private let text: String

    public init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .wkFont(.labelMono)
            .foregroundStyle(WKColor.textTertiary)
    }
}

#Preview {
    WKLabelMono("Week 2 · Day 1")
        .padding()
        .background(WKColor.bg)
}
