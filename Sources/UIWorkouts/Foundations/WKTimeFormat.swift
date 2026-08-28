import Foundation

/// Shared clock formatting for the timer components. Pure, so it is unit-tested.
public enum WKTimeFormat {
    /// `m:ss`, or `h:mm:ss` once the duration reaches an hour. Negative input
    /// clamps to zero.
    public static func clock(_ seconds: Int) -> String {
        let total = max(0, seconds)
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60
        if h > 0 {
            return String(format: "%d:%02d:%02d", h, m, s)
        }
        return String(format: "%d:%02d", m, s)
    }

    /// VoiceOver phrasing: "2 minutes 5 seconds".
    public static func spoken(_ seconds: Int) -> String {
        let total = max(0, seconds)
        let m = total / 60
        let s = total % 60
        var parts: [String] = []
        if m > 0 { parts.append("\(m) minute\(m == 1 ? "" : "s")") }
        if s > 0 || m == 0 { parts.append("\(s) second\(s == 1 ? "" : "s")") }
        return parts.joined(separator: " ")
    }
}
