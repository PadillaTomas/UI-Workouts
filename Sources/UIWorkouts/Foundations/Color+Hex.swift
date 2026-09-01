import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

extension Color {
    /// Build an opaque color from a `0xRRGGBB` integer. Use this only for values
    /// that are genuinely appearance-independent (e.g. a ``WKRamp`` stop seen the
    /// same way in both themes); semantic tokens pair two values via
    /// ``init(light:dark:)``.
    init(rgb hex: UInt32) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: 1.0)
    }

    /// Build a trait-adaptive color from a `0xRRGGBB` value per appearance.
    /// "Ambient Dark" is the primary theme; light stays AA. Call sites never
    /// branch on `colorScheme` — they read the token and it resolves itself.
    init(light: UInt32, dark: UInt32) {
        #if canImport(UIKit)
        self.init(uiColor: UIColor { traits in
            UIColor(rgb: traits.userInterfaceStyle == .dark ? dark : light)
        })
        #else
        self.init(rgb: dark)
        #endif
    }
}

#if canImport(UIKit)
extension UIColor {
    convenience init(rgb hex: UInt32) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255.0,
            green: CGFloat((hex >> 8) & 0xFF) / 255.0,
            blue: CGFloat(hex & 0xFF) / 255.0,
            alpha: 1.0
        )
    }
}
#endif
