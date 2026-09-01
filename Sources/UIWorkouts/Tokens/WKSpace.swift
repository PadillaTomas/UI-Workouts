import CoreGraphics

/// Layer 0 — spacing scale on a 4pt base (canvas section 1a). Unchanged in v2.
public enum WKSpace {
    public static let xs: CGFloat = 4
    public static let sm: CGFloat = 8
    public static let md: CGFloat = 12
    /// Standard screen gutter.
    public static let lg: CGFloat = 16
    public static let xl: CGFloat = 24
    public static let xxl: CGFloat = 32
    public static let xxxl: CGFloat = 56
}

/// Layer 0 — corner radii. "Ambient Dark" softens the containers (spec §2.4).
public enum WKRadius {
    /// Chips, small tags.
    public static let chip: CGFloat = 8
    /// Calendar cells.
    public static let cell: CGFloat = 12
    /// Cards.
    public static let card: CGFloat = 20
    /// Inset row groups (``WKInsetGroup``).
    public static let group: CGFloat = 20
    /// Sheets, large containers.
    public static let sheet: CGFloat = 28
    /// Fully rounded (buttons, dots).
    public static let pill: CGFloat = 999
}

/// Layer 0 — fixed sizes and hit targets (spec §2.4).
public enum WKSize {
    /// Minimum interactive target.
    public static let minTarget: CGFloat = 44
    /// Primary timer control height.
    public static let timerControl: CGFloat = 64
    /// ``WKInsetGroup`` row height.
    public static let rowHeight: CGFloat = 56
    /// ``WKAmbientBackground`` default height.
    public static let ambientHeight: CGFloat = 340
    /// ``WKArcGauge`` default diameter.
    public static let gaugeDiameter: CGFloat = 260
}
